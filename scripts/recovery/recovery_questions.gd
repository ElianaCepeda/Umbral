extends LevelState
class_name RecoveryQuestions

var permitir_hover := true
var pergamino_anim: AnimatedSprite2D

# CAMBIO: era ui_content: VBoxContainer, ahora:
var vbox_questions: VBoxContainer

var question_label: Label
var answer1: Button
var answer2: Button
var answer3: Button
var answer4: Button
var scoreattack_label: Label
var scoredefense1_label: Label
var scoredefense2_label: Label
var mensaje_feedback: Label

# ELIMINADA: var boton_terminado: Button

var attackpoints: int = 0
var defense1points: int = 0
var defense2points: int = 0
var first_question: int = 1
var last_question: int = 9
var current_question_index: int = 0
var correct_sound: AudioStreamPlayer
var wrong_sound: AudioStreamPlayer
var page_flip: AudioStreamPlayer  # se mantiene igual
var type: String
var correct_answer: int

# NUEVA: música de fondo
var music: AudioStreamPlayer


var questions = [
	{
		"number": 1,
		"question": "Retardo alarga el tiempo de reacción de Andrés. Insiste en manejar porque 'se siente bien'. ¿Por qué Retardo lo hace peligroso aunque él no lo perciba?",
		"answers": [
			"El bienestar subjetivo solo dura las dos primeras copas.",
			"El alcohol solo altera la visión periférica, no el tiempo de reacción.",
			"El cerebelo ya procesa estímulos con retraso aunque Andrés no lo sienta.",
			"La confianza excesiva lo lleva a ignorar señales de tráfico."
		],
		"correct": 3,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 2,
		"question": "Borroso representa la pérdida de agudeza visual. Andrés dice que 'todo se ve raro'. ¿Qué le hace Borroso a sus ojos?",
		"answers": [
			"La retina reduce su sensibilidad a los fotorreceptores de cono.",
			"El alcohol altera los músculos extraoculares: los ojos no convergen y generan visión doble.",
			"El nervio óptico se comprime por la presión intracraneal elevada.",
			"La pupila entra en exceso de luz y satura los fotorreceptores."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 3,
		"question": "Euforia genera falsa invencibilidad en Andrés. Comer antes de beber es una conducta protectora. ¿Por qué reduce el efecto de Euforia?",
		"answers": [
			"La comida elimina el alcohol del estómago antes de que se absorba.",
			"Protege la mucosa gástrica y ralentiza la absorción del alcohol, reduciendo el pico de intoxicación.",
			"La comida neutraliza el etanol convirtiéndolo en agua y CO₂.",
			"Solo funciona si se come después de beber, no antes."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 4,
		"question": "Retardo y Borroso afectan a Andrés al volante. Tomar agua mientras se bebe es una conducta protectora. ¿Qué efecto tiene sobre estos enemigos?",
		"answers": [
			"El agua elimina el alcohol del torrente sanguíneo más rápido.",
			"Hidratarse no tiene efecto real sobre los síntomas del alcohol.",
			"Reduce la velocidad de consumo y mantiene la hidratación, disminuyendo parcialmente la intoxicación.",
			"Solo ayuda con la resaca, no durante el consumo activo."
		],
		"correct": 3,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 5,
		"question": "Euforia nubla el juicio de Andrés. No mezclar alcohol con medicamentos es una conducta protectora. ¿Por qué protege frente a este enemigo?",
		"answers": [
			"Los medicamentos bloquean los receptores del alcohol en el cerebro.",
			"Solo aplica con antibióticos; con otros fármacos no hay interacción.",
			"Evita interacciones que potencian los efectos del alcohol y dañan el hígado y sistema nervioso.",
			"El alcohol anula los medicamentos pero no al revés."
		],
		"correct": 3,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 6,
		"question": "Hipertensión sobrecarga el corazón de Andrés tras años de consumo. ¿Cómo genera Hipertensión ese daño cardiovascular crónico?",
		"answers": [
			"Eleva triglicéridos que tapan las arterias y reducen su luz.",
			"El consumo crónico activa el simpático, endurece los vasos y fuerza al corazón a bombear con más presión.",
			"Estimula la aldosterona, retiene sodio y sube la presión de forma aguda.",
			"El daño hepático baja proteínas plasmáticas y paradójicamente sube la presión."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 7,
		"question": "Gastritis erosiona el estómago de Andrés con cada trago. ¿Qué hace Gastritis que la distingue del ardor ocasional?",
		"answers": [
			"Solo difieren en intensidad; el mecanismo de hipersecreción ácida es idéntico.",
			"Gastritis erosiona la mucosa y puede derivar en úlceras sangrantes; el ardor puntual no daña estructuralmente.",
			"El ardor ocasional es más grave porque el estómago no tiene tiempo de adaptarse.",
			"El alcohol eleva el pH gástrico, al contrario del ardor normal que lo baja."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 8,
		"question": "Cirrosis destruye el hígado de Andrés en silencio. ¿Cuál es el mecanismo celular por el que reemplaza tejido sano por tejido inútil?",
		"answers": [
			"El hígado prioriza el alcohol sobre la glucosa y acumula glucógeno tóxico.",
			"El acetaldehído genera estrés oxidativo que activa células estrelladas y deposita fibrosis irreversible.",
			"Suprime la bilis y las grasas se acumulan en los hepatocitos hasta destruirlos.",
			"El alcohol bloquea los conductos biliares e inflama el hígado desde afuera."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 9,
		"question": "Cirrosis daña el hígado de Andrés independientemente del tipo de bebida. ¿Qué hace incorrecta la creencia de que la cerveza es más segura?",
		"answers": [
			"Las bebidas fermentadas contienen antioxidantes que protegen parcialmente los hepatocitos.",
			"Cirrosis responde al etanol total consumido; el hígado procesa el mismo compuesto sin distinción.",
			"La cerveza daña más porque el lúpulo potencia la toxicidad del etanol.",
			"Es parcialmente correcta: la cerveza no genera acetaldehído en cantidades tóxicas."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 10,
		"question": "Cirrosis e Hipertensión avanzan en silencio. ¿Por qué el daño hepático por alcohol es especialmente grave comparado con el de otros órganos?",
		"answers": [
			"Cuando Cirrosis destruye el hígado, las toxinas se acumulan en sangre y dañan en cascada todos los demás órganos.",
			"Porque el hígado es el órgano más grande y su tamaño lo hace más vulnerable.",
			"Porque está cerca del corazón y las toxinas pasan directo a la circulación coronaria.",
			"Porque el hígado no puede regenerarse en ningún caso, ni siquiera parcialmente."
		],
		"correct": 1,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 11,
		"question": "Hipertensión contrae los vasos de Sofía al encender un cigarrillo. Ella dice que fumar la 'relaja'. ¿Qué hace Hipertensión en su cuerpo en los primeros 30 segundos?",
		"answers": [
			"El efecto vasoconstrictor solo ocurre tras años de consumo.",
			"Activa receptores parasimpáticos que reducen el ritmo cardíaco.",
			"Actúa sobre el sistema digestivo; la relajación percibida es muscular.",
			"La nicotina libera adrenalina, contrae los vasos y sube la presión: lo opuesto a relajarse."
		],
		"correct": 4,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 12,
		"question": "Monóxido de Carbono es invisible y silencioso. ¿Por qué es más dañino que otros componentes del humo para la oxigenación de Sofía?",
		"answers": [
			"Se acumula en el pulmón y es la causa directa de la EPOC.",
			"Reacciona con el nitrógeno del aire y forma compuestos que irritan la mucosa.",
			"Tiene afinidad por la hemoglobina 200 veces mayor que el O₂, formando carboxihemoglobina.",
			"Es el principal causante del cáncer porque daña el ADN de las células bronquiales."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 13,
		"question": "Taquicardia acelera el corazón de Sofía con cada cigarrillo. El ejercicio físico es una conducta protectora. ¿Cómo contrarresta a Taquicardia?",
		"answers": [
			"El ejercicio elimina la nicotina del organismo más rápido.",
			"Disminuye el deseo de fumar, mejora la función pulmonar y contrarresta parte del daño cardiovascular.",
			"Solo ayuda si se hace justo después de fumar.",
			"El ejercicio y el tabaco tienen efectos opuestos que se cancelan mutuamente."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 14,
		"question": "Hipertensión y Monóxido de Carbono dañan a Sofía en silencio. El parche de nicotina es una conducta protectora. ¿Por qué ayuda frente a estos enemigos?",
		"answers": [
			"El parche tiene nicotina que bloquea los receptores del humo en el pulmón.",
			"Aporta nicotina controlada sin toxinas del humo, reduciendo la ansiedad sin exponer el organismo al CO.",
			"Solo funciona si se combina con medicación antidepresiva.",
			"El parche elimina la dependencia física en menos de una semana."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 15,
		"question": "Taquicardia fuerza el corazón de Sofía a trabajar más. ¿Por qué Taquicardia es una alerta real y no una adaptación normal del cuerpo?",
		"answers": [
			"Taquicardia ocurre con vasoconstricción simultánea, sobrecargando el corazón sin beneficio adaptativo.",
			"Es equivalente a la taquicardia del ejercicio y tiene el mismo efecto cardioprotector.",
			"Solo es alerta si supera 120 ppm sostenidas; por debajo es respuesta adaptativa normal.",
			"Cualquier taquicardia sostenida produce hipertrofia ventricular irreversible desde el inicio."
		],
		"correct": 1,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 16,
		"question": "Ansiedad se dispara cuando Sofía intenta pasar un día sin fumar. ¿Qué proceso cerebral explica la irritabilidad que genera Ansiedad en abstinencia?",
		"answers": [
			"La ausencia de nicotina eleva el cortisol que activa la amígdala, similar al estrés postraumático.",
			"La nicotina ausente reduce serotonina límbica generando un episodio depresivo leve.",
			"Los receptores colinérgicos sobrexpresados quedan sin activar; el déficit dopaminérgico se siente como emergencia.",
			"Es solo hábito conductual; el cuerpo recuerda los momentos del día asociados al cigarrillo."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 17,
		"question": "Fatiga agota a Sofía aunque no haga esfuerzo. Lleva 20 años fumando. ¿Cómo genera Fatiga ese agotamiento crónico?",
		"answers": [
			"El monóxido deprime el sistema nervioso central; la fatiga es neurológica, no de oxigenación.",
			"El tabaco reduce los glóbulos rojos generando anemia crónica.",
			"El tabaco eleva el metabolismo basal y el cuerpo no puede sostener ese gasto energético extra.",
			"El daño alveolar y la carboxihemoglobina reducen el O₂; músculos y corazón trabajan más para el mismo esfuerzo."
		],
		"correct": 4,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 18,
		"question": "Ansiedad aparece cuando Sofía intenta dejar de fumar. ¿Por qué genera síntomas físicos tan intensos si el cigarrillo no es una 'droga dura'?",
		"answers": [
			"Los síntomas de Ansiedad son psicológicos; la dependencia de la nicotina es comparable a la de la cafeína.",
			"Ansiedad activa el sistema inmune, que ataca las células adaptadas a la nicotina.",
			"La nicotina reduce la densidad de receptores colinérgicos; al retirarla, el sistema queda en hiperexcitabilidad.",
			"El tabaco acumula sustancias en el tejido adiposo que se liberan al dejarlo."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 19,
		"question": "EPOC bloquea los pulmones de Sofía progresivamente. El médico dice que 'ya no se limpian solos'. ¿Qué estructura destruye EPOC?",
		"answers": [
			"El surfactante pulmonar, cuya degradación colapsa los alvéolos.",
			"Las células caliciformes, que producen el moco necesario para atrapar partículas.",
			"Los macrófagos alveolares, únicas células que eliminan partículas del parénquima.",
			"Las células ciliadas del epitelio bronquial, que EPOC paraliza y destruye progresivamente."
		],
		"correct": 4,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 20,
		"question": "EPOC destruye los pulmones de Sofía de forma irreversible. ¿Por qué no tiene cura completa aunque deje de fumar?",
		"answers": [
			"Se necesitaría terapia génica; los fármacos solo alivian síntomas sin revertir el daño.",
			"El alquitrán acumulado en los bronquios es una barrera física que no puede disolverse.",
			"Los alvéolos destruidos por EPOC se reemplazan por espacios aéreos inservibles que no se regeneran.",
			"El sistema inmune queda sensibilizado y continúa atacando el pulmón."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 21,
		"question": "Conjuntivitis representa el enrojecimiento ocular que delata a Lucas. ¿Cuál es el mecanismo por el que aparece incluso sin humo?",
		"answers": [
			"El humo irrita la conjuntiva directamente, igual que la conjuntivitis alérgica.",
			"El nervio trigémino comparte inervación con los vasos oculares y se activa ante cualquier sustancia.",
			"El THC activa receptores CB1 en los vasos conjuntivales causando vasodilatación incluso por vía oral.",
			"La marihuana baja la presión intraocular y los capilares se dilatan como compensación."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 22,
		"question": "Apetito impulsa a Lucas a comer compulsivamente solo cuando fuma. ¿Cómo genera Apetito hambre sin déficit calórico real?",
		"answers": [
			"La marihuana sube el metabolismo generando déficit calórico genuino en minutos.",
			"El THC baja la glucemia activando el hipotálamo para señalizar hambre real.",
			"El efecto es psicológico: la asociación repetida entre consumir y comer crea hambre condicionada.",
			"El THC activa receptores CB1 en el hipotálamo y el vago, amplificando el apetito sin importar las reservas."
		],
		"correct": 4,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 23,
		"question": "Problemas respiratorios inflaman los pulmones de Lucas. Dormir bien es una conducta protectora. ¿Cómo ayuda frente a este enemigo?",
		"answers": [
			"El sueño no tiene relación directa con los síntomas respiratorios del cannabis.",
			"Dormir elimina el THC acumulado en los pulmones durante el día.",
			"El consumo más la falta de sueño elevan la ansiedad y el riesgo de crisis; descansar reduce esa carga.",
			"Solo ayuda si se duerme más de 10 horas consecutivas."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 24,
		"question": "Conjuntivitis y Apetito afectan a Lucas visiblemente. Controlar la temperatura del entorno es una conducta protectora. ¿Por qué reduce estos efectos?",
		"answers": [
			"El frío contrae los vasos oculares y neutraliza la vasodilatación de Conjuntivitis.",
			"El calor excesivo agrava la deshidratación y las complicaciones físicas; un entorno adecuado reduce ese riesgo.",
			"La temperatura no tiene efecto sobre los síntomas de la marihuana.",
			"Solo aplica en consumo por inhalación; por vía oral la temperatura es irrelevante."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 25,
		"question": "Problemas respiratorios inflaman los pulmones de Lucas aunque diga que 'no es tabaco'. ¿Qué tienen en común con el tabaco y qué los diferencia?",
		"answers": [
			"El humo de marihuana no contiene alquitrán; la irritación es temporal y reversible.",
			"Problemas respiratorios solo aparecen cuando la marihuana se mezcla con tabaco.",
			"Ambos inflaman bronquios e inactivan cilios; las caladas de marihuana son más profundas y llegan a zonas más distales.",
			"La marihuana afecta alvéolos y el tabaco solo bronquios; por eso la progresión es distinta."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 26,
		"question": "Memoria corto plazo borra los recuerdos recientes de Lucas. ¿Qué estructura y mecanismo explican el daño que produce este enemigo?",
		"answers": [
			"El THC activa receptores CB1 en el hipocampo, inhibiendo la LTP necesaria para consolidar memorias recientes.",
			"El THC reduce el flujo prefrontal, única región responsable de la memoria de trabajo.",
			"Memoria corto plazo afecta la amígdala; por eso Lucas solo olvida eventos con carga emocional.",
			"Fragmenta el sueño REM donde ocurre la consolidación; el olvido es indirecto."
		],
		"correct": 1,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 27,
		"question": "Ideación paranoide hace que Lucas sienta que todos lo juzgan justo después de fumar. ¿Qué circuito neurológico activa para producir esa experiencia?",
		"answers": [
			"Sube serotonina en la corteza cingulada, que malinterpreta estímulos sociales neutros.",
			"Ideación paranoide sobreactiva la amígdala y reduce la corteza prefrontal; el miedo se amplifica sin freno racional.",
			"Genera hiperatención social por exceso de dopamina prefrontal, sin alterar la evaluación racional.",
			"Solo ocurre en personas con variante genética del gen COMT; en los demás el efecto es ansiolítico."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 28,
		"question": "Desbalance motor arruina la precisión de Lucas con la guitarra. ¿Qué región cerebral afecta para deteriorar la coordinación fina?",
		"answers": [
			"El efecto es periférico: actúa en las uniones neuromusculares distales, no en el SNC.",
			"Los ganglios basales gestionan la memoria procedimental; Lucas recuerda cómo tocar pero no puede ejecutarlo.",
			"Desbalance motor activa receptores CB1 en el cerebelo, alterando el timing motor y la coordinación.",
			"Daña la corteza motora primaria reduciendo la velocidad de conducción nerviosa."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 29,
		"question": "Ideación paranoide convierte situaciones cotidianas en amenazas para Lucas. ¿Cómo transforma estímulos neutros en sospechas?",
		"answers": [
			"Solo actúa a concentraciones de THC superiores al 20%.",
			"Sensibiliza los circuitos mesolímbicos, atribuyendo carga amenazante a estímulos neutros.",
			"Agudiza la percepción social; Lucas puede estar detectando señales reales que antes ignoraba.",
			"Solo ocurre durante la intoxicación aguda; las sospechas persistentes de Lucas son de otra causa."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 30,
		"question": "Memoria corto plazo paraliza la motivación creativa de Lucas. Lleva meses sin crear. ¿Qué efecto neurológico explica esa parálisis?",
		"answers": [
			"Eleva adenosina generando letargia crónica independiente del sistema de recompensa.",
			"Desensibiliza los receptores CB1 del circuito de recompensa; nada genera placer basal sin THC.",
			"Sube el umbral dopaminérgico solo durante el sueño, bloqueando metas a largo plazo.",
			"Es efecto del aislamiento social, no neurológico; se resolvería con reintegración."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 31,
		"question": "Dependencia convierte el uso recreativo de Mateo en necesidad diaria. ¿Qué proceso neurobiológico explica esa transición tan rápida?",
		"answers": [
			"La cocaína tiene vida media larga que acumula niveles plasmáticos que fuerzan a consumir más.",
			"Dependencia desensibiliza los receptores D2 con picos de dopamina extremos; sin cocaína, nada genera placer.",
			"La cocaína daña el hígado desde las primeras dosis, haciendo cada dosis siguiente más intensa.",
			"Dependencia es principalmente psicológica; la transición rápida refleja personalidad adictiva."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 32,
		"question": "Ideación paranoide hace que Mateo deje de confiar en sus amigos. ¿Cuál es el mecanismo neurológico que alimenta a este enemigo?",
		"answers": [
			"Agota la serotonina del rafe, generando un estado depresivo que distorsiona la percepción.",
			"Altera los receptores de oxitocina prefrontal reduciendo la capacidad de generar confianza.",
			"Es consecuencia del aislamiento social, no un efecto neurológico directo.",
			"Sobreactiva el locus coeruleus y sensibiliza la amígdala; la hipervigilancia deriva en sospecha patológica."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 33,
		"question": "Insomnio suprime la fatiga de Mateo aunque lleve días sin dormir. Evitar consumir tras ejercicio intenso es una conducta protectora. ¿Por qué?",
		"answers": [
			"El ejercicio elimina la cocaína del organismo más rápido por sudoración.",
			"Después del ejercicio el corazón ya está acelerado; consumir en ese estado multiplica el riesgo cardiovascular.",
			"Solo aplica en personas con condiciones cardíacas previas.",
			"El ejercicio y la cocaína tienen efectos opuestos que se cancelan mutuamente."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 34,
		"question": "Convulsiones puede aparecer en Mateo sin historial epiléptico. No mezclar con alcohol es una conducta protectora. ¿Por qué reduce el riesgo?",
		"answers": [
			"El alcohol ralentiza la absorción de la cocaína y reduce su concentración en sangre.",
			"Ambas sustancias se neutralizan mutuamente en el hígado sin generar metabolitos.",
			"Evita la formación de cocaetileno, una sustancia que incrementa la toxicidad cardiovascular y el riesgo de crisis.",
			"Solo importa no mezclarlos en la misma hora; con más tiempo entre consumos no hay riesgo."
		],
		"correct": 3,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 35,
		"question": "Insomnio e Ideación paranoide deterioran a Mateo en silencio. Controlar la dosis es una conducta protectora. ¿Qué reduce exactamente?",
		"answers": [
			"Controlar la dosis elimina la dependencia física en pocas semanas.",
			"Solo reduce el riesgo de sobredosis aguda pero no los efectos crónicos.",
			"Espaciar y limitar el consumo reduce el riesgo de sobredosis y la intensidad de los efectos adversos.",
			"El control de dosis no tiene efecto sobre la dependencia una vez que esta se establece."
		],
		"correct": 3,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 36,
		"question": "Necrosis destruye el intestino de Mateo en silencio. ¿Por qué el efecto vasoconstrictor de la cocaína es especialmente peligroso en esa zona?",
		"answers": [
			"El daño solo ocurre por vía oral; por vía nasal no alcanza la circulación esplácnica.",
			"El intestino tiene alta demanda de O₂; la vasoconstricción interrumpe la absorción de forma reversible.",
			"El daño lo producen los adulterantes; la vasoconstricción por cocaína pura es insignificante.",
			"La circulación mesentérica tiene poca red colateral; Necrosis puede avanzar a tejido muerto irreversible sin avisar."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 37,
		"question": "Arritmia desregula el corazón de Mateo, que siente latidos irregulares. ¿Qué proceso electrofisiológico desencadena Arritmia?",
		"answers": [
			"Las palpitaciones son efecto de la ansiedad crónica sobre el nodo sinoatrial.",
			"Agota el potasio intracelular del miocardio, alterando la polarización de forma predecible.",
			"Solo genera taquicardia regular vía adrenalina; no afecta la conducción eléctrica.",
			"Arritmia bloquea canales de sodio cardíacos y eleva catecolaminas; puede generar hasta fibrilación ventricular."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 38,
		"question": "Necrosis convierte un dolor leve en emergencia de vida. ¿Por qué este enemigo es tan grave aunque los síntomas iniciales sean leves?",
		"answers": [
			"Solo es emergencia cuando afecta más del 30% del intestino; daños menores se recuperan.",
			"El intestino tiene alta capacidad regenerativa pero la cocaína inhibe ese proceso.",
			"Necrosis perfora la barrera mucosa; bacterias generan sepsis mortal en horas y el tejido no se recupera.",
			"El dolor lleva a urgencias donde se descubre el consumo y los anestésicos interactúan."
		],
		"correct": 3,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 39,
		"question": "Pérdida de apetito hace que Mateo casi no coma aunque su cuerpo se deteriore. ¿Qué mecanismo neurológico usa para suprimir el hambre?",
		"answers": [
			"Eleva dopamina en el hipotálamo lateral, suprimiendo el hambre aunque las reservas energéticas se agoten.",
			"El efecto supresor dura solo la primera semana; la pérdida extrema de Mateo debe tener otra causa.",
			"Contrae el estómago reduciendo la motilidad; sin señales de vacío gástrico no hay hambre.",
			"Estimula los receptores de leptina en el hipotálamo, generando saciedad artificial permanente."
		],
		"correct": 1,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 40,
		"question": "Arritmia puede ser fatal incluso la primera vez en Mateo. El cuidado nasal es una conducta protectora. ¿Qué protege exactamente?",
		"answers": [
			"El suero nasal elimina la cocaína antes de que llegue al torrente sanguíneo.",
			"Mantener la higiene nasal reduce la inflamación, previene infecciones y disminuye el daño en el tabique.",
			"Solo aplica en consumidores de más de 5 años; antes el tabique no presenta daño.",
			"El cuidado nasal protege exclusivamente el sistema respiratorio, no el cardiovascular."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	}
];

func _init(min_val: int = 1, max_val: int = 9):
	level_name = "Recovery"
	scene_path = "res://scenes/recovery/question_room.tscn"
	timeline_name = ""
	enemy_type = ""
	first_question = min_val-1
	last_question = max_val

func enter():
	print("Entrando al minijuego de recuperación...")

	if preloaded_scene:
		scene_instance = preloaded_scene.instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada en RecoveryState")
		return

	# --- Sonidos opcionales ---
	correct_sound = scene_instance.get_node_or_null("CorrectSound")
	wrong_sound   = scene_instance.get_node_or_null("WrongSound")
	
	# --- Nodos principales ---
	var holder    = scene_instance.get_node("CenterContainer/QuestionsHolder")
	pergamino_anim = holder.get_node("Animation")

	# --- VBoxDescription (pantalla inicial) ---
	var vbox_desc     = holder.get_node("VBoxDescription")
	var btn_siguiente = vbox_desc.get_node("DescriptionContainer/Siguiente")

	# --- VBoxQuestions (pantalla de preguntas) ---
	vbox_questions = holder.get_node("VBoxQuestions")

	# AnswersContainer exterior contiene MarginContainer y el AnswersContainer interior
	var answers_outer  = vbox_questions.get_node("AnswersContainer")
	var margin_container = answers_outer.get_node("MarginContainer")
	question_label = margin_container.get_node("QuestionLabel")

	# El AnswersContainer interior es donde están los Answer + Empty
	var answers_inner = answers_outer.get_node("AnswersContainer")

	answer1 = answers_inner.get_node("Answer1")
	answer2 = answers_inner.get_node("Answer2")
	answer3 = answers_inner.get_node("Answer3")
	answer4 = answers_inner.get_node("Answer4")

	# Labels de puntaje en HBoxContainer dentro de VBoxQuestions
	var hbox             = vbox_questions.get_node("HBoxContainer")
	scoreattack_label    = hbox.get_node("LabelAtack")
	scoredefense1_label  = hbox.get_node("LabelDefense1")
	scoredefense2_label  = hbox.get_node("LabelDefense2")

	mensaje_feedback = vbox_questions.get_node("LabelFeedback")

	# --- Estado inicial de la UI ---
	vbox_questions.hide()
	vbox_desc.hide()
	mensaje_feedback.text = ""

	scoreattack_label.text   = str("Ataque: ",   attackpoints)
	scoredefense1_label.text = str("Defensa1: ", defense1points)
	scoredefense2_label.text = str("Defensa2: ", defense2points)

	# --- Música ---
	if music:
		music.play()

	# --- Animación de apertura ---
	await get_tree().create_timer(1.0).timeout
	pergamino_anim.play("open")
	if page_flip:
		page_flip.play()
	await pergamino_anim.animation_finished
	vbox_desc.show() 

	# --- Conectar botón Siguiente ---
	btn_siguiente.pressed.connect(_on_siguiente_pressed.bind(vbox_desc))

	# --- Conectar botones de respuesta ---
	answer1.pressed.connect(check_answer.bind(1))
	answer2.pressed.connect(check_answer.bind(2))
	answer3.pressed.connect(check_answer.bind(3))
	answer4.pressed.connect(check_answer.bind(4))

	# --- Hover visual ---
	for btn in [answer1, answer2, answer3, answer4]:
		btn.mouse_entered.connect(func(): show_hover_btn(btn))
		btn.mouse_exited.connect(func():  hide_hover_btn(btn))


# ─── Flujo: Siguiente ────────────────────────────────────────────────────────

func _on_siguiente_pressed(vbox_desc: Node) -> void:
	vbox_desc.hide()
	vbox_questions.show()
	current_question_index = first_question
	load_question(current_question_index)


# ─── Cargar pregunta ─────────────────────────────────────────────────────────

func load_question(count: int) -> void:
	permitir_hover = true
	var q = questions[count]

	# Mezclar respuestas aleatoriamente
	var indices = [0, 1, 2, 3]
	indices.shuffle()

	var shuffled_answers = []
	var new_correct = 1
	for i in range(4):
		shuffled_answers.append(q["answers"][indices[i]])
		if indices[i] == q["correct"] - 1:
			new_correct = i + 1

	correct_answer = new_correct
	type           = q["type"]

	question_label.text = q["question"]

	answer1.get_node("MarginContainer/Label").text = shuffled_answers[0]
	answer2.get_node("MarginContainer/Label").text = shuffled_answers[1]
	answer3.get_node("MarginContainer/Label").text = shuffled_answers[2]
	answer4.get_node("MarginContainer/Label").text = shuffled_answers[3]

	cambiar_estado_botones(false)


# ─── Verificar respuesta ──────────────────────────────────────────────────────

func check_answer(answer: int) -> void:
	permitir_hover = false
	cambiar_estado_botones(true)

	if answer == correct_answer:
		if correct_sound:
			correct_sound.play()
			await get_tree().create_timer(0.5).timeout
		await add_points()
	else:
		if wrong_sound:
			wrong_sound.play()
			await get_tree().create_timer(0.5).timeout
		await sub_points()

	scoreattack_label.text   = str("Ataque: ",   attackpoints)
	scoredefense1_label.text = str("Defensa1: ", defense1points)
	scoredefense2_label.text = str("Defensa2: ", defense2points)

	current_question_index += 1

	if current_question_index < last_question:
		load_question(current_question_index)
	else:
		print("¡Se acabaron las preguntas de esta ronda!")
		await _finalizar_minijuego()


# ─── Puntos ───────────────────────────────────────────────────────────────────

func add_points() -> void:
	if type == "Attack":
		attackpoints += 5
		await mostrar_feedback_temporal("¡Correcto! +5 puntos de ataque", Color.DARK_GREEN)
	else:
		var select = randi_range(1, 2)
		if select == 1:
			defense1points += 2
			await mostrar_feedback_temporal("¡Correcto! +2 puntos de defensa 1", Color.DARK_GREEN)
		else:
			defense2points += 2
			await mostrar_feedback_temporal("¡Correcto! +2 puntos de defensa 2", Color.DARK_GREEN)


func sub_points() -> void:
	if type == "Attack":
		attackpoints -= 2
		await mostrar_feedback_temporal("Incorrecto. -2 puntos de ataque", Color.DARK_RED)
	else:
		var select = randi_range(1, 2)
		if select == 1:
			defense1points -= 1
			await mostrar_feedback_temporal("Incorrecto. -1 punto de defensa 1", Color.DARK_RED)
		else:
			defense2points -= 1
			await mostrar_feedback_temporal("Incorrecto. -1 punto de defensa 2", Color.DARK_RED)


# ─── Feedback temporal ────────────────────────────────────────────────────────

func mostrar_feedback_temporal(texto: String, color: Color) -> void:
	mensaje_feedback.text = texto
	mensaje_feedback.add_theme_color_override("font_color", color)
	await get_tree().create_timer(2.0).timeout
	mensaje_feedback.text = ""


# ─── Cierre automático al terminar ───────────────────────────────────────────

func _finalizar_minijuego() -> void:
	cambiar_estado_botones(true)
	vbox_questions.hide()

	await get_tree().create_timer(0.5).timeout

	var final_attack  = 1 + attackpoints
	var unlock_def1   = 1 if defense1points > 0 else 0
	var unlock_def2   = 1 if defense2points > 0 else 0

	SaveManager.sync_and_save_player_state(
		100,
		100,
		final_attack,
		unlock_def1,
		unlock_def2
	)

	# Cerrar pergamino con animación inversa
	pergamino_anim.play_backwards("open")
	await pergamino_anim.animation_finished
	await get_tree().create_timer(0.3).timeout

	GameManager.preguntas_completadas = true
	GameManager.change_level(RecoveryState.new())


# ─── Helpers de botones ───────────────────────────────────────────────────────

func cambiar_estado_botones(deshabilitados: bool) -> void:
	answer1.disabled = deshabilitados
	answer2.disabled = deshabilitados
	answer3.disabled = deshabilitados
	answer4.disabled = deshabilitados

func show_hover_btn(boton: Button) -> void:
	boton.get_node("NinePatchRect").modulate = Color(0.7, 0.9, 1.2)

func hide_hover_btn(boton: Button) -> void:
	boton.get_node("NinePatchRect").modulate = Color(1, 1, 1)
