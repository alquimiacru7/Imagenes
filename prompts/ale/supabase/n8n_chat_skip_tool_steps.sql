-- Regla (trigger) sobre la memoria de Ale: public.n8n_chat_histories
-- Aplicada el 11/10/2026 en el proyecto alquimia-cru-kb.
--
-- Por qué: con Claude (Anthropic) la memoria de n8n guardaba pasos intermedios
-- con bloques tool_use sin su tool_result. En los turnos siguientes Anthropic
-- rechazaba el historial ("tool_use ids were found without tool_result blocks")
-- y contestaba el modelo de respaldo (gpt-4.1) en lugar de Haiku.
-- Ahora, de los mensajes 'ai' en bloques se guarda solo el texto.

create or replace function public.n8n_chat_skip_tool_steps()
returns trigger
language plpgsql
as $function$
declare
  texto text;
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

  return new;
end;
$function$;

-- El trigger ya existía:
-- CREATE TRIGGER n8n_chat_skip_tool_steps_trg BEFORE INSERT ON public.n8n_chat_histories
--   FOR EACH ROW EXECUTE FUNCTION n8n_chat_skip_tool_steps();
