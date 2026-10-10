# Pruebas para el prompt de Ale (v2)

Cómo usarla: abre una conversación nueva con el agente en n8n (con un número de prueba y el CRM vacío, salvo que la prueba diga otra cosa), manda los mensajes del lead uno por uno y revisa que la respuesta cumpla lo de "Debe". Si falla, anota qué contestó.

Supuesto: la fecha de hoy es anterior al 20 de noviembre de 2026.

## A. Primer contacto

| # | Mensajes del lead | Debe |
|---|---|---|
| A1 | "Hola, me interesan sus servicios!" | Presentarse como Ale y pedir el nombre. Nada de preguntas de evento. |
| A2 | "Hola me puede proporcionar los precios" | Igual que A1. Sin precios. |
| A3 | "Hola, es para la boda de mi hija, 120 invitados" | Reaccionar a la boda, presentarse y pedir el nombre. Sin preguntar fecha ni ciudad. |
| A4 | "información y disponibilidad para 28/11/26" (fecha ocupada en el calendario de prueba) | Llamar check_availability en ese turno; presentarse y decir en ESE primer mensaje que no hay disponibilidad; ofrecer alternativas. |
| A5 | Igual que A4 pero con fecha libre | Presentarse, decir que está libre y pedir el nombre. |
| A6 | Perfil de WhatsApp "Taller Mecánico Ruiz", el lead nunca da su nombre | Nunca llamarlo "Ruiz" ni guardarlo como nombre en el CRM. |
| A7 | "¿Eres un bot?" | Admitir que es la asistente virtual, con naturalidad, y seguir la plática. |
| A8 | (sin preguntar si es bot) plática normal | Nunca mencionar que es asistente virtual. |

## B. Fechas

| # | Mensajes del lead | Debe |
|---|---|---|
| B1 | "Es para el 16/01" | Preguntar SOLO el año, afirmando: "¿el 16 de enero sería del 2027, verdad?" |
| B2 | Después de B1: "Domingo del 2026" | Tomar 2026 como el año; no volver a pedir la fecha. |
| B3 | "El sábado 21 de noviembre" | No confirmar ni corregir el día de la semana: "perfecto, el 21 de noviembre". |
| B4 | Cualquier fecha | Nunca decir el día de la semana. |
| B5 | Cotizado para el 5 de diciembre, luego "perdón, siempre no, es el 12 de diciembre" | Responder de inmediato, volver a revisar disponibilidad y aclarar si cambia algo. |
| B6 | "Cena familiar, 70 personas, entre el 19 y el 23 de enero, ¿precio?" | No cotizar; pedir el día exacto una sola vez. Si dice "todavía no sé", cerrar con calidez sin insistir. |
| B7 | "Boda de 200 en Hermosillo, diciembre del año que entra" | Cotizar con "diciembre de 2027 (día por confirmar)" sin correr check_availability; ofrecer complementos. |
| B8 | "Cumpleaños, finales de enero" | No afirmar disponibilidad de ningún día. |

## C. Servicios, fechas y tipos de evento

| # | Situación | Debe |
|---|---|---|
| C1 | Cumpleaños del 24 de octubre, "¿manejan por cantidad de bebidas o libre?" | Desde la primera respuesta: "para el 24 de octubre lo que tenemos es Barra Libre", y explicarla. No describir la opción por pieza. |
| C2 | Boda civil del 16 de octubre, 100 personas, "bebidas durante dos horas" | Explicar que Barra Libre son 5 horas al mismo precio; preguntar si así la cotiza. Nunca "ajustarla" a 2 horas. |
| C3 | Boda del 4 de diciembre, 100 invitados | Ofrecer Recepción Premium y Barra de Shots como complementos (después de check_availability de cada uno). No mencionar el "20 de noviembre". |
| C4 | Boda del 24 de octubre | No ofrecer complementos. |
| C5 | XV años del 10 de enero de 2027 | Solo Barra Libre y Recepción Premium. Nunca Shots ni Mimosas. |
| C6 | "¿Tienen paquete sin alcohol para XV años?" | Decir que no hay servicio sin alcohol; las opciones sin alcohol incluidas son agua natural, mineral y refrescos. |
| C7 | Boda | Nunca ofrecer Recovery Bar ni Mimosas, salvo que mencione postboda o brunch. |
| C8 | Boda del 20 de diciembre + "y al otro día una tornaboda" | Recovery Bar con fecha del 21 de diciembre, decírselo explícitamente. |
| C9 | "Quiero solo la Barra de Shots" | Explicar que solo se vende como complemento y ofrecer la combinación. |
| C10 | Boda del 5 de diciembre, "quiero la barra solo una hora entre la ceremonia y la recepción" | Ofrecer Recepción Premium, no "horas extra". |
| C11 | "Es una comida de 2 a 10 pm" (Barra Libre) | Avisar que son 3 horas extra y preguntar con cuántas horas cotizar. No decir el precio de la hora extra. |
| C12 | "¿Cuánto cuesta la hora extra?" | "$6,000 por hora, aplica en Barra Libre." |
| C13 | Lead pide "barra de coctelería" sin especificar | Explicar que Barra Libre es sin límite para todo el evento antes de cotizar. |

## D. Invitados

| # | Situación | Debe |
|---|---|---|
| D1 | "Es un brunch para 30 mujeres" y después piden cotizar | No volver a preguntar cuántas personas son. |
| D2 | Cumpleaños de 35, evento del 12 de diciembre | Decir que Barra Libre no aplica; ofrecer Mimosas y/o Recepción Premium. No escalar. |
| D3 | Boda de 30, evento del 25 de octubre | Decir que para su fecha no hay opción; cierre cálido. No ofrecer servicios que no alcanzan. |
| D4 | Lead con 30-35 en el CRM que escribe solo "OK" | Aplicar el mínimo; no empujarlo a Barra Libre. |
| D5 | "Mío 50" (cumpleaños) | Entender que cumple 50 años; preguntar los invitados aparte. |
| D6 | "Son 15 para el 20 de marzo 2027" | Entenderlo como XV años; preguntar cuántos invitados. No aplicar el mínimo con 15. |
| D7 | "Seríamos 150-200" | Preguntar con cuál cotiza. |
| D8 | Postboda de 30 | Decir con honestidad que no hay opción. No escalar. |

## E. Cotización

| # | Situación | Debe |
|---|---|---|
| E1 | Ya tiene fecha confirmada, 100 invitados, Hermosillo, nombre y servicio | Cotizar en ese turno, sin preguntar "¿te la preparo?". Responder SIN_MENSAJE con nota. |
| E2 | Tiene todo menos la ciudad | Pedir la ciudad amarrada a su evento; no cotizar todavía. |
| E3 | San Carlos | Mencionar el 15% extra y cotizar con ciudad San Carlos. |
| E4 | Guaymas | Decir que no hay cobertura; no escalar ni ofrecer pasar datos. |
| E5 | Ya cotizado y pide agregar Recepción Premium | Una sola cotización nueva con todos los servicios. |
| E6 | Ya cotizado y dice "quiero apartar" | No recotizar; notify_owner y mensaje de despedida mencionando su evento. |
| E7 | "Ok" a la pregunta de complementos | Cotizar solo Barra Libre, sin volver a preguntar. |
| E8 | Después de send_quote | log_lead con Etapa "Cotizado" y monto limpio ANTES de SIN_MENSAJE. |
| E9 | Nunca da su nombre | Pedirlo una vez al cotizar; si no lo da, cotizar a "Estimado cliente". |

## F. Después de cotizar y cierres

| # | Situación | Debe |
|---|---|---|
| F1 | "Lo checo, muchas gracias" | Una línea cálida, sin mencionar anticipo. |
| F2 | Luego 👏 | SIN_MENSAJE \| Lead cerró la plática, no se respondió. |
| F3 | "Voy a hacer la transferencia" | Respuesta cálida, sin escalar todavía. |
| F4 | "Ya hice el anticipo" | notify_owner + mensaje de despedida. |
| F5 | "¿Me pasas la CLABE?" | No escribirla; decir que viene en la cotización. |

## G. Catálogo y preguntas

| # | Situación | Debe |
|---|---|---|
| G1 | "Mándame el catálogo" sin otros datos | Mandarlo en ese turno sin pedir nada; log_lead "Catálogo enviado" antes; mensaje corto con recomendación y una pregunta. |
| G2 | "¿Qué servicios tienen?" | Contestar en el chat (2-3 líneas), no mandar el catálogo. |
| G3 | "¿Qué cócteles trae la Recepción Premium?" | Mandar el catálogo. |
| G4 | "Vi una barra a 80 pesos por persona, están carísimos" | Explicar qué incluye, sin precios, sin hablar de la competencia, sin descuento. |
| G5 | "¿Me hacen descuento?" y después insiste | Primero la política; si insiste, notify_owner. |
| G6 | "¿Hay degustación?" (cumpleaños, no boda) | Explicar costo, dinámica y 15 días; sin escalar. |
| G7 | "Quiero agendar la degustación" | Dar la información y después notify_owner. |
| G8 | "¿Tienen fotos de eventos?" | Arrancamos en septiembre 2026, aún no. |
| G9 | "¿Puedo pagar en efectivo?" | notify_owner. |
| G10 | Lead manda un sticker después de despedirse | Tratarlo como cierre (F2). |
| G11 | Lead manda una foto de su invitación de boda con fecha | Usar la fecha de la invitación (revisar disponibilidad) sin pedirla otra vez. A ti te llega la foto por Telegram. |
| G13 | Lead manda una foto que OpenAI no pudo describir | Pedir que lo escriba; no fingir que la vio. |
| G14 | Lead manda foto de un comprobante de transferencia | Tratarlo como anticipo hecho: notify_owner + mensaje de despedida. |
| G15 | Lead comparte la ubicación de un salón en Hermosillo | Tomar Hermosillo como ciudad, sin preguntarla. |
| G16 | Lead comparte una ubicación en Guaymas | Decir que no hay cobertura ahí. |
| G17 | Lead reacciona con 👍 a un mensaje | No pasa nada: ni respuesta al lead ni alerta a Telegram. |
| G12 | "Tengo 16 años y quiero barra para mi fiesta" | Despedirse amablemente y notify_owner. |

## H. Formato (revisar en todas)

- Un solo emoji por mensaje.
- Sin doble asterisco, sin viñetas, sin encabezados.
- Sin "si quieres", "cualquier duda me dices", "quedo al pendiente" (salvo cierres).
- Una sola pregunta por mensaje (salvo las combinadas permitidas).
- No repetir la celebración del tipo de evento.
