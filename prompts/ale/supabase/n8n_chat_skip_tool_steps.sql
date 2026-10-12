-- Regla (trigger) sobre la memoria de Ale: public.n8n_chat_histories
-- Aplicada el 11/10/2026 en el proyecto alquimia-cru-kb.
--
-- Por qué: con Claude (Anthropic) la memoria de n8n guardaba pasos intermedios
-- con bloques tool_use sin su tool_result. En los turnos siguientes Anthropic
-- rechazaba el historial ("tool_use ids were found without tool_result blocks")
-- y contestaba el modelo de respaldo (gpt-4.1) en lugar de Haiku.
-- Ahora, de los mensajes 'ai' en bloques se guarda solo el texto.
--
-- 12/10/2026: Haiku sin razonamiento extendido llego a escribir su analisis en
-- ingles ANTES del mensaje para el lead. El flujo ya lo filtra antes de enviarlo
-- (nodo "Procesar output"); aqui se quita tambien de la memoria para que no
-- contamine el historial. Se descartan los parrafos iniciales que parecen ingles
-- (2 o mas palabras distintas de una lista de palabras solo-inglesas). Si todo el
-- mensaje parece ingles, se guarda completo (el lead escribio en ingles).

create or replace function public.n8n_chat_skip_tool_steps()
returns trigger
language plpgsql
as $function$
declare
  texto text;
  parrafos text[];
  i int := 1;
  limpio text;
begin
  -- Resultado de una herramienta: no aporta al hilo de la conversacion.
  if new.message->>'type' = 'tool' then
    return null;
  end if;

  -- Turno 'ai' con contenido en bloques (formato de Claude: thinking, tool_use, text)
  -- o lista vacia (OpenAI con solo tool_calls). Se guarda solo el texto; si no hay
  -- texto, no se guarda. Asi nunca queda un tool_use sin su tool_result en memoria.
  if new.message->>'type' = 'ai'
     and jsonb_typeof(new.message->'content') = 'array' then
    select string_agg(b->>'text', E'\n')
      into texto
      from jsonb_array_elements(new.message->'content') b
     where b->>'type' = 'text' and btrim(coalesce(b->>'text', '')) <> '';
    if texto is null then
      return null;
    end if;
    new.message := jsonb_set(new.message, '{content}', to_jsonb(texto));
    return new;
  end if;

  -- Turno 'ai' con texto vacio.
  if new.message->>'type' = 'ai'
     and jsonb_typeof(new.message->'content') = 'string'
     and btrim(new.message->>'content') = '' then
    return null;
  end if;

  -- Turno 'ai' que empieza con analisis interno en ingles: se quitan esos parrafos.
  if new.message->>'type' = 'ai'
     and jsonb_typeof(new.message->'content') = 'string' then
    parrafos := regexp_split_to_array(new.message->>'content', E'\\n[ \\t]*\\n');
    while i <= coalesce(array_length(parrafos, 1), 0)
      and (select count(distinct lower(m[1]))
             from regexp_matches(parrafos[i],
               '\m(the|is|are|rules?|need|skip|answer|ask|first|should|with|this|that|then|since|because|already|reply|per|but|will|keep|simple)\M',
               'gi') m) >= 2
    loop
      i := i + 1;
    end loop;
    -- Solo se limpia si queda al menos un parrafo normal despues del analisis.
    -- Si TODO el mensaje parece ingles (el lead escribio en ingles), se guarda completo.
    if i > 1 and i <= array_length(parrafos, 1) then
      limpio := btrim(array_to_string(parrafos[i:], E'\n\n'));
      if limpio <> '' then
        new.message := jsonb_set(new.message, '{content}', to_jsonb(limpio));
      end if;
    end if;
  end if;

  return new;
end;
$function$;

-- El trigger ya existía:
-- CREATE TRIGGER n8n_chat_skip_tool_steps_trg BEFORE INSERT ON public.n8n_chat_histories
--   FOR EACH ROW EXECUTE FUNCTION n8n_chat_skip_tool_steps();
