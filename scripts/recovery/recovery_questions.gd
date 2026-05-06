extends LevelState
class_name RecoveryQuestions
var permitir_hover := true
var pergamino_anim: AnimatedSprite2D
var ui_content: VBoxContainer
var question_label: Label
var answer1: Button
var answer2: Button
var answer3: Button
var answer4: Button
var scoreattack_label: Label
var scoredefense1_label: Label
var scoredefense2_label: Label
var mensaje_feedback: Label
var boton_terminado: Button

var attackpoints: int = 0
var defense1points : int = 0
var defense2points : int = 0
var first_question: int = 1
var last_question: int = 9
var current_question_index: int = 0
var correct_sound: AudioStreamPlayer
var wrong_sound: AudioStreamPlayer
var page_flip: AudioStreamPlayer
var type:String
var correct_answer: int


var questions = [
	{
		"number": 1,
		"question": "Retardo alarga el tiempo de reacción de Andrés. Insiste en manejar porque 'se siente bien'. ¿Por qué Retardo lo hace peligroso aunque él no lo perciba?",
		"answers": [
			"A)  El bienestar subjetivo solo dura las dos primeras copas.",
			"B)  El alcohol solo altera la visión periférica, no el tiempo de reacción.",
			"C)  El cerebelo ya procesa estímulos con retraso aunque Andrés no lo sienta.",
			"D)  La confianza excesiva lo lleva a ignorar señales de tráfico."
		],
		"correct": 3,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 2,
		"question": "Borroso representa la pérdida de agudeza visual. Andrés dice que 'todo se ve raro'. ¿Qué le hace Borroso a sus ojos?",
		"answers": [
			"A)  La retina reduce su sensibilidad a los fotorreceptores de cono.",
			"B)  El alcohol altera los músculos extraoculares: los ojos no convergen y generan visión doble.",
			"C)  El nervio óptico se comprime por la presión intracraneal elevada.",
			"D)  La pupila entra en exceso de luz y satura los fotorreceptores."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 3,
		"question": "Euforia genera falsa invencibilidad en Andrés. Comer antes de beber es una conducta protectora. ¿Por qué reduce el efecto de Euforia?",
		"answers": [
			"A)  La comida elimina el alcohol del estómago antes de que se absorba.",
			"B)  Protege la mucosa gástrica y ralentiza la absorción del alcohol, reduciendo el pico de intoxicación.",
			"C)  La comida neutraliza el etanol convirtiéndolo en agua y CO₂.",
			"D)  Solo funciona si se come después de beber, no antes."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 4,
		"question": "Retardo y Borroso afectan a Andrés al volante. Tomar agua mientras se bebe es una conducta protectora. ¿Qué efecto tiene sobre estos enemigos?",
		"answers": [
			"A)  El agua elimina el alcohol del torrente sanguíneo más rápido.",
			"B)  Hidratarse no tiene efecto real sobre los síntomas del alcohol.",
			"C)  Reduce la velocidad de consumo y mantiene la hidratación, disminuyendo parcialmente la intoxicación.",
			"D)  Solo ayuda con la resaca, no durante el consumo activo."
		],
		"correct": 3,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 5,
		"question": "Euforia nubla el juicio de Andrés. No mezclar alcohol con medicamentos es una conducta protectora. ¿Por qué protege frente a este enemigo?",
		"answers": [
			"A)  Los medicamentos bloquean los receptores del alcohol en el cerebro.",
			"B)  Solo aplica con antibióticos; con otros fármacos no hay interacción.",
			"C)  Evita interacciones que potencian los efectos del alcohol y dañan el hígado y sistema nervioso.",
			"D)  El alcohol anula los medicamentos pero no al revés."
		],
		"correct": 3,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 6,
		"question": "Hipertensión sobrecarga el corazón de Andrés tras años de consumo. ¿Cómo genera Hipertensión ese daño cardiovascular crónico?",
		"answers": [
			"A)  Eleva triglicéridos que tapan las arterias y reducen su luz.",
			"B)  El consumo crónico activa el simpático, endurece los vasos y fuerza al corazón a bombear con más presión.",
			"C)  Estimula la aldosterona, retiene sodio y sube la presión de forma aguda.",
			"D)  El daño hepático baja proteínas plasmáticas y paradójicamente sube la presión."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 7,
		"question": "Gastritis erosiona el estómago de Andrés con cada trago. ¿Qué hace Gastritis que la distingue del ardor ocasional?",
		"answers": [
			"A)  Solo difieren en intensidad; el mecanismo de hipersecreción ácida es idéntico.",
			"B)  Gastritis erosiona la mucosa y puede derivar en úlceras sangrantes; el ardor puntual no daña estructuralmente.",
			"C)  El ardor ocasional es más grave porque el estómago no tiene tiempo de adaptarse.",
			"D)  El alcohol eleva el pH gástrico, al contrario del ardor normal que lo baja."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 8,
		"question": "Cirrosis destruye el hígado de Andrés en silencio. ¿Cuál es el mecanismo celular por el que reemplaza tejido sano por tejido inútil?",
		"answers": [
			"A)  El hígado prioriza el alcohol sobre la glucosa y acumula glucógeno tóxico.",
			"B)  El acetaldehído genera estrés oxidativo que activa células estrelladas y deposita fibrosis irreversible.",
			"C)  Suprime la bilis y las grasas se acumulan en los hepatocitos hasta destruirlos.",
			"D)  El alcohol bloquea los conductos biliares e inflama el hígado desde afuera."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 9,
		"question": "Cirrosis daña el hígado de Andrés independientemente del tipo de bebida. ¿Qué hace incorrecta la creencia de que la cerveza es más segura?",
		"answers": [
			"A)  Las bebidas fermentadas contienen antioxidantes que protegen parcialmente los hepatocitos.",
			"B)  Cirrosis responde al etanol total consumido; el hígado procesa el mismo compuesto sin distinción.",
			"C)  La cerveza daña más porque el lúpulo potencia la toxicidad del etanol.",
			"D)  Es parcialmente correcta: la cerveza no genera acetaldehído en cantidades tóxicas."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 10,
		"question": "Cirrosis e Hipertensión avanzan en silencio. ¿Por qué el daño hepático por alcohol es especialmente grave comparado con el de otros órganos?",
		"answers": [
			"A)  Cuando Cirrosis destruye el hígado, las toxinas se acumulan en sangre y dañan en cascada todos los demás órganos.",
			"B)  Porque el hígado es el órgano más grande y su tamaño lo hace más vulnerable.",
			"C)  Porque está cerca del corazón y las toxinas pasan directo a la circulación coronaria.",
			"D)  Porque el hígado no puede regenerarse en ningún caso, ni siquiera parcialmente."
		],
		"correct": 1,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 11,
		"question": "Hipertensión contrae los vasos de Sofía al encender un cigarrillo. Ella dice que fumar la 'relaja'. ¿Qué hace Hipertensión en su cuerpo en los primeros 30 segundos?",
		"answers": [
			"A)  El efecto vasoconstrictor solo ocurre tras años de consumo.",
			"B)  Activa receptores parasimpáticos que reducen el ritmo cardíaco.",
			"C)  Actúa sobre el sistema digestivo; la relajación percibida es muscular.",
			"D)  La nicotina libera adrenalina, contrae los vasos y sube la presión: lo opuesto a relajarse."
		],
		"correct": 4,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 12,
		"question": "Monóxido de Carbono es invisible y silencioso. ¿Por qué es más dañino que otros componentes del humo para la oxigenación de Sofía?",
		"answers": [
			"A)  Se acumula en el pulmón y es la causa directa de la EPOC.",
			"B)  Reacciona con el nitrógeno del aire y forma compuestos que irritan la mucosa.",
			"C)  Tiene afinidad por la hemoglobina 200 veces mayor que el O₂, formando carboxihemoglobina.",
			"D)  Es el principal causante del cáncer porque daña el ADN de las células bronquiales."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 13,
		"question": "Taquicardia acelera el corazón de Sofía con cada cigarrillo. El ejercicio físico es una conducta protectora. ¿Cómo contrarresta a Taquicardia?",
		"answers": [
			"A)  El ejercicio elimina la nicotina del organismo más rápido.",
			"B)  Disminuye el deseo de fumar, mejora la función pulmonar y contrarresta parte del daño cardiovascular.",
			"C)  Solo ayuda si se hace justo después de fumar.",
			"D)  El ejercicio y el tabaco tienen efectos opuestos que se cancelan mutuamente."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 14,
		"question": "Hipertensión y Monóxido de Carbono dañan a Sofía en silencio. El parche de nicotina es una conducta protectora. ¿Por qué ayuda frente a estos enemigos?",
		"answers": [
			"A)  El parche tiene nicotina que bloquea los receptores del humo en el pulmón.",
			"B)  Aporta nicotina controlada sin toxinas del humo, reduciendo la ansiedad sin exponer el organismo al CO.",
			"C)  Solo funciona si se combina con medicación antidepresiva.",
			"D)  El parche elimina la dependencia física en menos de una semana."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 15,
		"question": "Taquicardia fuerza el corazón de Sofía a trabajar más. ¿Por qué Taquicardia es una alerta real y no una adaptación normal del cuerpo?",
		"answers": [
			"A)  Taquicardia ocurre con vasoconstricción simultánea, sobrecargando el corazón sin beneficio adaptativo.",
			"B)  Es equivalente a la taquicardia del ejercicio y tiene el mismo efecto cardioprotector.",
			"C)  Solo es alerta si supera 120 ppm sostenidas; por debajo es respuesta adaptativa normal.",
			"D)  Cualquier taquicardia sostenida produce hipertrofia ventricular irreversible desde el inicio."
		],
		"correct": 1,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 16,
		"question": "Ansiedad se dispara cuando Sofía intenta pasar un día sin fumar. ¿Qué proceso cerebral explica la irritabilidad que genera Ansiedad en abstinencia?",
		"answers": [
			"A)  La ausencia de nicotina eleva el cortisol que activa la amígdala, similar al estrés postraumático.",
			"B)  La nicotina ausente reduce serotonina límbica generando un episodio depresivo leve.",
			"C)  Los receptores colinérgicos sobrexpresados quedan sin activar; el déficit dopaminérgico se siente como emergencia.",
			"D)  Es solo hábito conductual; el cuerpo recuerda los momentos del día asociados al cigarrillo."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 17,
		"question": "Fatiga agota a Sofía aunque no haga esfuerzo. Lleva 20 años fumando. ¿Cómo genera Fatiga ese agotamiento crónico?",
		"answers": [
			"A)  El monóxido deprime el sistema nervioso central; la fatiga es neurológica, no de oxigenación.",
			"B)  El tabaco reduce los glóbulos rojos generando anemia crónica.",
			"C)  El tabaco eleva el metabolismo basal y el cuerpo no puede sostener ese gasto energético extra.",
			"D)  El daño alveolar y la carboxihemoglobina reducen el O₂; músculos y corazón trabajan más para el mismo esfuerzo."
		],
		"correct": 4,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 18,
		"question": "Ansiedad aparece cuando Sofía intenta dejar de fumar. ¿Por qué genera síntomas físicos tan intensos si el cigarrillo no es una 'droga dura'?",
		"answers": [
			"A)  Los síntomas de Ansiedad son psicológicos; la dependencia de la nicotina es comparable a la de la cafeína.",
			"B)  Ansiedad activa el sistema inmune, que ataca las células adaptadas a la nicotina.",
			"C)  La nicotina reduce la densidad de receptores colinérgicos; al retirarla, el sistema queda en hiperexcitabilidad.",
			"D)  El tabaco acumula sustancias en el tejido adiposo que se liberan al dejarlo."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 19,
		"question": "EPOC bloquea los pulmones de Sofía progresivamente. El médico dice que 'ya no se limpian solos'. ¿Qué estructura destruye EPOC?",
		"answers": [
			"A)  El surfactante pulmonar, cuya degradación colapsa los alvéolos.",
			"B)  Las células caliciformes, que producen el moco necesario para atrapar partículas.",
			"C)  Los macrófagos alveolares, únicas células que eliminan partículas del parénquima.",
			"D)  Las células ciliadas del epitelio bronquial, que EPOC paraliza y destruye progresivamente."
		],
		"correct": 4,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 20,
		"question": "EPOC destruye los pulmones de Sofía de forma irreversible. ¿Por qué no tiene cura completa aunque deje de fumar?",
		"answers": [
			"A)  Se necesitaría terapia génica; los fármacos solo alivian síntomas sin revertir el daño.",
			"B)  El alquitrán acumulado en los bronquios es una barrera física que no puede disolverse.",
			"C)  Los alvéolos destruidos por EPOC se reemplazan por espacios aéreos inservibles que no se regeneran.",
			"D)  El sistema inmune queda sensibilizado y continúa atacando el pulmón."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 21,
		"question": "Conjuntivitis representa el enrojecimiento ocular que delata a Lucas. ¿Cuál es el mecanismo por el que aparece incluso sin humo?",
		"answers": [
			"A)  El humo irrita la conjuntiva directamente, igual que la conjuntivitis alérgica.",
			"B)  El nervio trigémino comparte inervación con los vasos oculares y se activa ante cualquier sustancia.",
			"C)  El THC activa receptores CB1 en los vasos conjuntivales causando vasodilatación incluso por vía oral.",
			"D)  La marihuana baja la presión intraocular y los capilares se dilatan como compensación."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 22,
		"question": "Apetito impulsa a Lucas a comer compulsivamente solo cuando fuma. ¿Cómo genera Apetito hambre sin déficit calórico real?",
		"answers": [
			"A)  La marihuana sube el metabolismo generando déficit calórico genuino en minutos.",
			"B)  El THC baja la glucemia activando el hipotálamo para señalizar hambre real.",
			"C)  El efecto es psicológico: la asociación repetida entre consumir y comer crea hambre condicionada.",
			"D)  El THC activa receptores CB1 en el hipotálamo y el vago, amplificando el apetito sin importar las reservas."
		],
		"correct": 4,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 23,
		"question": "Problemas respiratorios inflaman los pulmones de Lucas. Dormir bien es una conducta protectora. ¿Cómo ayuda frente a este enemigo?",
		"answers": [
			"A)  El sueño no tiene relación directa con los síntomas respiratorios del cannabis.",
			"B)  Dormir elimina el THC acumulado en los pulmones durante el día.",
			"C)  El consumo más la falta de sueño elevan la ansiedad y el riesgo de crisis; descansar reduce esa carga.",
			"D)  Solo ayuda si se duerme más de 10 horas consecutivas."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 24,
		"question": "Conjuntivitis y Apetito afectan a Lucas visiblemente. Controlar la temperatura del entorno es una conducta protectora. ¿Por qué reduce estos efectos?",
		"answers": [
			"A)  El frío contrae los vasos oculares y neutraliza la vasodilatación de Conjuntivitis.",
			"B)  El calor excesivo agrava la deshidratación y las complicaciones físicas; un entorno adecuado reduce ese riesgo.",
			"C)  La temperatura no tiene efecto sobre los síntomas de la marihuana.",
			"D)  Solo aplica en consumo por inhalación; por vía oral la temperatura es irrelevante."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 25,
		"question": "Problemas respiratorios inflaman los pulmones de Lucas aunque diga que 'no es tabaco'. ¿Qué tienen en común con el tabaco y qué los diferencia?",
		"answers": [
			"A)  El humo de marihuana no contiene alquitrán; la irritación es temporal y reversible.",
			"B)  Problemas respiratorios solo aparecen cuando la marihuana se mezcla con tabaco.",
			"C)  Ambos inflaman bronquios e inactivan cilios; las caladas de marihuana son más profundas y llegan a zonas más distales.",
			"D)  La marihuana afecta alvéolos y el tabaco solo bronquios; por eso la progresión es distinta."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 26,
		"question": "Memoria corto plazo borra los recuerdos recientes de Lucas. ¿Qué estructura y mecanismo explican el daño que produce este enemigo?",
		"answers": [
			"A)  El THC activa receptores CB1 en el hipocampo, inhibiendo la LTP necesaria para consolidar memorias recientes.",
			"B)  El THC reduce el flujo prefrontal, única región responsable de la memoria de trabajo.",
			"C)  Memoria corto plazo afecta la amígdala; por eso Lucas solo olvida eventos con carga emocional.",
			"D)  Fragmenta el sueño REM donde ocurre la consolidación; el olvido es indirecto."
		],
		"correct": 1,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 27,
		"question": "Ideación paranoide hace que Lucas sienta que todos lo juzgan justo después de fumar. ¿Qué circuito neurológico activa para producir esa experiencia?",
		"answers": [
			"A)  Sube serotonina en la corteza cingulada, que malinterpreta estímulos sociales neutros.",
			"B)  Ideación paranoide sobreactiva la amígdala y reduce la corteza prefrontal; el miedo se amplifica sin freno racional.",
			"C)  Genera hiperatención social por exceso de dopamina prefrontal, sin alterar la evaluación racional.",
			"D)  Solo ocurre en personas con variante genética del gen COMT; en los demás el efecto es ansiolítico."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 28,
		"question": "Desbalance motor arruina la precisión de Lucas con la guitarra. ¿Qué región cerebral afecta para deteriorar la coordinación fina?",
		"answers": [
			"A)  El efecto es periférico: actúa en las uniones neuromusculares distales, no en el SNC.",
			"B)  Los ganglios basales gestionan la memoria procedimental; Lucas recuerda cómo tocar pero no puede ejecutarlo.",
			"C)  Desbalance motor activa receptores CB1 en el cerebelo, alterando el timing motor y la coordinación.",
			"D)  Daña la corteza motora primaria reduciendo la velocidad de conducción nerviosa."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 29,
		"question": "Ideación paranoide convierte situaciones cotidianas en amenazas para Lucas. ¿Cómo transforma estímulos neutros en sospechas?",
		"answers": [
			"A)  Solo actúa a concentraciones de THC superiores al 20%.",
			"B)  Sensibiliza los circuitos mesolímbicos, atribuyendo carga amenazante a estímulos neutros.",
			"C)  Agudiza la percepción social; Lucas puede estar detectando señales reales que antes ignoraba.",
			"D)  Solo ocurre durante la intoxicación aguda; las sospechas persistentes de Lucas son de otra causa."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 30,
		"question": "Memoria corto plazo paraliza la motivación creativa de Lucas. Lleva meses sin crear. ¿Qué efecto neurológico explica esa parálisis?",
		"answers": [
			"A)  Eleva adenosina generando letargia crónica independiente del sistema de recompensa.",
			"B)  Desensibiliza los receptores CB1 del circuito de recompensa; nada genera placer basal sin THC.",
			"C)  Sube el umbral dopaminérgico solo durante el sueño, bloqueando metas a largo plazo.",
			"D)  Es efecto del aislamiento social, no neurológico; se resolvería con reintegración."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 31,
		"question": "Dependencia convierte el uso recreativo de Mateo en necesidad diaria. ¿Qué proceso neurobiológico explica esa transición tan rápida?",
		"answers": [
			"A)  La cocaína tiene vida media larga que acumula niveles plasmáticos que fuerzan a consumir más.",
			"B)  Dependencia desensibiliza los receptores D2 con picos de dopamina extremos; sin cocaína, nada genera placer.",
			"C)  La cocaína daña el hígado desde las primeras dosis, haciendo cada dosis siguiente más intensa.",
			"D)  Dependencia es principalmente psicológica; la transición rápida refleja personalidad adictiva."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 32,
		"question": "Ideación paranoide hace que Mateo deje de confiar en sus amigos. ¿Cuál es el mecanismo neurológico que alimenta a este enemigo?",
		"answers": [
			"A)  Agota la serotonina del rafe, generando un estado depresivo que distorsiona la percepción.",
			"B)  Altera los receptores de oxitocina prefrontal reduciendo la capacidad de generar confianza.",
			"C)  Es consecuencia del aislamiento social, no un efecto neurológico directo.",
			"D)  Sobreactiva el locus coeruleus y sensibiliza la amígdala; la hipervigilancia deriva en sospecha patológica."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 33,
		"question": "Insomnio suprime la fatiga de Mateo aunque lleve días sin dormir. Evitar consumir tras ejercicio intenso es una conducta protectora. ¿Por qué?",
		"answers": [
			"A)  El ejercicio elimina la cocaína del organismo más rápido por sudoración.",
			"B)  Después del ejercicio el corazón ya está acelerado; consumir en ese estado multiplica el riesgo cardiovascular.",
			"C)  Solo aplica en personas con condiciones cardíacas previas.",
			"D)  El ejercicio y la cocaína tienen efectos opuestos que se cancelan mutuamente."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 34,
		"question": "Convulsiones puede aparecer en Mateo sin historial epiléptico. No mezclar con alcohol es una conducta protectora. ¿Por qué reduce el riesgo?",
		"answers": [
			"A)  El alcohol ralentiza la absorción de la cocaína y reduce su concentración en sangre.",
			"B)  Ambas sustancias se neutralizan mutuamente en el hígado sin generar metabolitos.",
			"C)  Evita la formación de cocaetileno, una sustancia que incrementa la toxicidad cardiovascular y el riesgo de crisis.",
			"D)  Solo importa no mezclarlos en la misma hora; con más tiempo entre consumos no hay riesgo."
		],
		"correct": 3,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 35,
		"question": "Insomnio e Ideación paranoide deterioran a Mateo en silencio. Controlar la dosis es una conducta protectora. ¿Qué reduce exactamente?",
		"answers": [
			"A)  Controlar la dosis elimina la dependencia física en pocas semanas.",
			"B)  Solo reduce el riesgo de sobredosis aguda pero no los efectos crónicos.",
			"C)  Espaciar y limitar el consumo reduce el riesgo de sobredosis y la intensidad de los efectos adversos.",
			"D)  El control de dosis no tiene efecto sobre la dependencia una vez que esta se establece."
		],
		"correct": 3,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 36,
		"question": "Necrosis destruye el intestino de Mateo en silencio. ¿Por qué el efecto vasoconstrictor de la cocaína es especialmente peligroso en esa zona?",
		"answers": [
			"A)  El daño solo ocurre por vía oral; por vía nasal no alcanza la circulación esplácnica.",
			"B)  El intestino tiene alta demanda de O₂; la vasoconstricción interrumpe la absorción de forma reversible.",
			"C)  El daño lo producen los adulterantes; la vasoconstricción por cocaína pura es insignificante.",
			"D)  La circulación mesentérica tiene poca red colateral; Necrosis puede avanzar a tejido muerto irreversible sin avisar."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 37,
		"question": "Arritmia desregula el corazón de Mateo, que siente latidos irregulares. ¿Qué proceso electrofisiológico desencadena Arritmia?",
		"answers": [
			"A)  Las palpitaciones son efecto de la ansiedad crónica sobre el nodo sinoatrial.",
			"B)  Agota el potasio intracelular del miocardio, alterando la polarización de forma predecible.",
			"C)  Solo genera taquicardia regular vía adrenalina; no afecta la conducción eléctrica.",
			"D)  Arritmia bloquea canales de sodio cardíacos y eleva catecolaminas; puede generar hasta fibrilación ventricular."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 38,
		"question": "Necrosis convierte un dolor leve en emergencia de vida. ¿Por qué este enemigo es tan grave aunque los síntomas iniciales sean leves?",
		"answers": [
			"A)  Solo es emergencia cuando afecta más del 30% del intestino; daños menores se recuperan.",
			"B)  El intestino tiene alta capacidad regenerativa pero la cocaína inhibe ese proceso.",
			"C)  Necrosis perfora la barrera mucosa; bacterias generan sepsis mortal en horas y el tejido no se recupera.",
			"D)  El dolor lleva a urgencias donde se descubre el consumo y los anestésicos interactúan."
		],
		"correct": 3,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 39,
		"question": "Pérdida de apetito hace que Mateo casi no coma aunque su cuerpo se deteriore. ¿Qué mecanismo neurológico usa para suprimir el hambre?",
		"answers": [
			"A)  Eleva dopamina en el hipotálamo lateral, suprimiendo el hambre aunque las reservas energéticas se agoten.",
			"B)  El efecto supresor dura solo la primera semana; la pérdida extrema de Mateo debe tener otra causa.",
			"C)  Contrae el estómago reduciendo la motilidad; sin señales de vacío gástrico no hay hambre.",
			"D)  Estimula los receptores de leptina en el hipotálamo, generando saciedad artificial permanente."
		],
		"correct": 1,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 40,
		"question": "Arritmia puede ser fatal incluso la primera vez en Mateo. El cuidado nasal es una conducta protectora. ¿Qué protege exactamente?",
		"answers": [
			"A)  El suero nasal elimina la cocaína antes de que llegue al torrente sanguíneo.",
			"B)  Mantener la higiene nasal reduce la inflamación, previene infecciones y disminuye el daño en el tabique.",
			"C)  Solo aplica en consumidores de más de 5 años; antes el tabique no presenta daño.",
			"D)  El cuidado nasal protege exclusivamente el sistema respiratorio, no el cardiovascular."
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
	correct_sound = scene_instance.get_node("CorrectSound")
	wrong_sound = scene_instance.get_node("WrongSound")
	var holder = scene_instance.get_node("CenterContainer/QuestionsHolder")
	var ui_root = holder.get_node("VBoxContainer")
	var answers_root = ui_root.get_node("AnswersContainer")
	var buttons_root = answers_root.get_node("AnswersContainer")

	pergamino_anim = holder.get_node("Animation")
	ui_content = ui_root

	question_label = answers_root.get_node("MarginContainer/QuestionLabel")

	var answer1_row = buttons_root.get_node("Answer1Row")
	var answer2_row = buttons_root.get_node("Answer2Row")
	var answer3_row = buttons_root.get_node("Answer3Row")
	var answer4_row = buttons_root.get_node("Answer4Row")

	answer1 = answer1_row.get_node("Answer1")
	answer2 = answer2_row.get_node("Answer2")
	answer3 = answer3_row.get_node("Answer3")
	answer4 = answer4_row.get_node("Answer4")

	scoreattack_label = ui_root.get_node("HBoxContainer/LabelAtack")
	scoredefense1_label = ui_root.get_node("HBoxContainer/LabelDefense1")
	scoredefense2_label = ui_root.get_node("HBoxContainer/LabelDefense2")

	mensaje_feedback = ui_root.get_node("LabelFeedback")
	boton_terminado = ui_root.get_node("Terminado")

	ui_content.hide()
	boton_terminado.hide()
	mensaje_feedback.text = ""
	page_flip = scene_instance.get_node_or_null("PageFlip")
	await get_tree().create_timer(1.0).timeout

	pergamino_anim.play("open")

	if page_flip:
		page_flip.play()
	await pergamino_anim.animation_finished

	ui_content.show()
	answer1.mouse_entered.connect(func(): show_hover_btn(answer1))
	answer1.mouse_exited.connect(func(): hide_hover_btn(answer1))

	answer2.mouse_entered.connect(func(): show_hover_btn(answer2))
	answer2.mouse_exited.connect(func(): hide_hover_btn(answer2))

	answer3.mouse_entered.connect(func(): show_hover_btn(answer3))
	answer3.mouse_exited.connect(func(): hide_hover_btn(answer3))

	answer4.mouse_entered.connect(func(): show_hover_btn(answer4))
	answer4.mouse_exited.connect(func(): hide_hover_btn(answer4))
	
	answer1.mouse_entered.connect(func():show_arrow(answer1))
	answer1.mouse_exited.connect(func(): hide_arrow(answer1))

	answer2.mouse_entered.connect(func(): show_arrow(answer2))
	answer2.mouse_exited.connect(func(): hide_arrow(answer2))

	answer3.mouse_entered.connect(func():show_arrow(answer3))
	answer3.mouse_exited.connect(func(): hide_arrow(answer3))

	answer4.mouse_entered.connect(func(): show_arrow(answer4))
	answer4.mouse_exited.connect(func(): hide_arrow(answer4))

	scoreattack_label.text = str("Ataque: ", attackpoints)
	scoredefense1_label.text = str("Defensa1: ", defense1points)
	scoredefense2_label.text = str("Defensa2: ", defense2points)

	answer1.pressed.connect(check_answer.bind(1))
	answer2.pressed.connect(check_answer.bind(2))
	answer3.pressed.connect(check_answer.bind(3))
	answer4.pressed.connect(check_answer.bind(4))
	boton_terminado.pressed.connect(_on_boton_terminado_pressed)
	var arrow1 = answer1_row.get_node("Arrow")
	var arrow2 = answer2_row.get_node("Arrow")
	var arrow3 = answer3_row.get_node("Arrow")
	var arrow4 = answer4_row.get_node("Arrow")

	arrow1.hide()
	arrow2.hide()
	arrow3.hide()
	arrow4.hide()

	current_question_index = first_question
	load_question(current_question_index)
	


func hide_arrows() -> void:
	for boton in [answer1, answer2, answer3, answer4]:
		var row = boton.get_parent()
		row.get_node("Arrow").hide()

func show_hover_btn(boton: Button) -> void:
	boton.get_node("NinePatchRect").modulate = Color(0.7, 0.9, 1.2)

func hide_hover_btn(boton: Button) -> void:
	boton.get_node("NinePatchRect").modulate = Color(1, 1, 1)

func show_arrow(boton: Button) -> void:
	if not permitir_hover:
		return
	
	var arrow = boton.get_parent().get_node("Arrow")
	arrow.show()
	arrow.position.x = -12
	arrow.create_tween().tween_property(arrow, "position:x", -6, 0.1)
	
func hide_arrow(boton: Button) -> void:
	var row = boton.get_parent()
	row.get_node("Arrow").hide()


func load_question(count:int):
	permitir_hover = true
	var q = questions[count]
	
	var indices = [0, 1, 2, 3]
	indices.shuffle()
	
	var shuffled_answers = []
	var new_correct = 1
	for i in range(4):
		shuffled_answers.append(q["answers"][indices[i]])
		# si el índice original coincide, guardamos posicion nueva
		if indices[i] == q["correct"] - 1:
			new_correct = i + 1  
 
	correct_answer = new_correct

	# Pregunta principal
	question_label.text = q["question"]

	
	answer1.get_node("MarginContainer/Label").text = shuffled_answers[0]
	answer2.get_node("MarginContainer/Label").text = shuffled_answers[1]
	answer3.get_node("MarginContainer/Label").text = shuffled_answers[2]
	answer4.get_node("MarginContainer/Label").text = shuffled_answers[3]
 

	type = q["type"]

	cambiar_estado_botones(false)
	

func check_answer(answer):
	permitir_hover = false   
	cambiar_estado_botones(true)
	
	if answer == correct_answer:
		if correct_sound:
			print("ENTRA EN CORRECT SOUND")
			correct_sound.play()
			await get_tree().create_timer(0.5).timeout
		add_points()
	else:
		if wrong_sound:
			print("ENTRA EN CORRECT SOUND")
			wrong_sound.play()
			await get_tree().create_timer(0.5).timeout
		sub_points()
		
	scoreattack_label.text = str("Ataque: ",attackpoints)
	scoredefense1_label.text = str("Defensa1: ",defense1points)
	scoredefense2_label.text = str("Defensa2: ",defense2points)
	
	current_question_index += 1
	if current_question_index < last_question:
		load_question(current_question_index)
	else:
		print("¡Se acabaron las preguntas de esta ronda!")
		
		hide_arrows()
		cambiar_estado_botones(true)
		boton_terminado.show()

func add_points ():
	if type == "Attack":
		attackpoints +=5
		await mostrar_feedback_temporal("Respuesta Correcta tienes 5 puntos más de ataque", Color.DARK_GREEN)
		
	else:
		var select = randi_range(1, 2)
		if select == 1:
			defense1points+=2
			await mostrar_feedback_temporal("Respuesta Correcta tienes 2 puntos más de defensa 1", Color.DARK_GREEN)
			
		else:
			defense2points+=2
			await mostrar_feedback_temporal("Respuesta Correcta tienes 2 puntos más de defensa 2", Color.DARK_GREEN)
			

func sub_points ():
	if type == "Attack":
		attackpoints -=2
		await mostrar_feedback_temporal("Respuesta Incorrecta tienes 2 puntos menos de ataque", Color.DARK_RED)
		
	else:
		var select = randi_range(1, 2)
		if select == 1:
			defense1points-=1
			await mostrar_feedback_temporal("Respuesta Incorrecta tienes 1 punto menos de defensa 1", Color.DARK_RED)
			
		else:
			defense2points-=1
			await mostrar_feedback_temporal("Respuesta Incorrecta tienes 1 punto menos de defensa 2", Color.DARK_RED)
				


func mostrar_feedback_temporal(texto_mensaje: String, color: Color) -> void:
	mensaje_feedback.text = texto_mensaje
	mensaje_feedback.add_theme_color_override("font_color", color)

	await get_tree().create_timer(2.0).timeout

	mensaje_feedback.text = ""
	
func cambiar_estado_botones(deshabilitados: bool):
	answer1.disabled = deshabilitados
	answer2.disabled = deshabilitados
	answer3.disabled = deshabilitados
	answer4.disabled = deshabilitados

func _on_boton_terminado_pressed():
	ui_content.hide()
	await get_tree().create_timer(0.5).timeout
	
	var final_attack = 1 + attackpoints
	var unlock_def1 = 1 if defense1points > 0 else 0
	var unlock_def2 = 1 if defense2points > 0 else 0
	
	SaveManager.sync_and_save_player_state(
		100, 
		100,                             
		final_attack,                
		unlock_def1,
		unlock_def2
	)
	
	pergamino_anim.play_backwards("open")
	if page_flip:
		page_flip.play()
	await pergamino_anim.animation_finished
	await get_tree().create_timer(0.3).timeout
	# Guardamos el estado globalmente antes de irnos
	GameManager.preguntas_completadas = true
	GameManager.change_level(RecoveryState.new())
	
