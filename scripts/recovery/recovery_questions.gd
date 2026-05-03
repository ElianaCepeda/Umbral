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
@onready var page_flip = $PageFlip

var type:String
var correct_answer: int
func _ready():
	await get_tree().create_timer(0.5).timeout
	if page_flip:
		page_flip.play()

var questions = [
	# ─────────────────────────────────────────────
	# ALCOHOL — Fase 1: Consecuencias a Corto Plazo
	# ─────────────────────────────────────────────

	{
		"number": 1,
		"question": "Andrés insiste en que puede manejar después de beber porque 'se siente bien'. ¿Cuál es la razón más precisa por la que esta percepción es peligrosa desde el punto de vista neurológico?",
		"answers": [
			"A)  Porque la confianza excesiva lo hace ignorar señales de tráfico.",
			"B)  Porque aunque su corteza prefrontal reprime la ansiedad, el cerebelo y el tronco encefálico ya procesan los estímulos con retraso, afectando la reacción antes de que él lo perciba.",
			"C)  Porque el alcohol altera la visión periférica específicamente, no el tiempo de reacción central.",
			"D)  Porque el bienestar subjetivo solo ocurre con las primeras dos copas y luego desaparece."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 2,
		"question": "Después de varias copas, Andrés dice que 'todo se ve un poco raro'. ¿Qué está pasando fisiológicamente en sus ojos?",
		"answers": [
			"A)  La pupila se dilata tanto que entra exceso de luz y genera distorsión.",
			"B)  El alcohol altera la coordinación de los músculos extraoculares, impidiendo que ambos ojos converjan en el mismo punto y generando visión doble o borrosa.",
			"C)  El nervio óptico se comprime por el aumento de presión intracraneal que produce el alcohol.",
			"D)  La retina reduce temporalmente su sensibilidad a los fotorreceptores de cono."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 3,
		"question": "Andrés se siente invencible después del segundo trago y toma decisiones impulsivas. ¿Qué proceso cerebral explica mejor esa sensación de bienestar?",
		"answers": [
			"A)  El alcohol activa directamente los receptores de serotonina 5-HT3, generando bienestar duradero.",
			"B)  El alcohol potencia la actividad GABAérgica y libera dopamina en el núcleo accumbens, creando una falsa sensación de recompensa que inhibe el juicio crítico de la corteza prefrontal.",
			"C)  El alcohol estimula la producción de endorfinas en el hipotálamo, lo que disminuye permanentemente el umbral de dolor.",
			"D)  El efecto de bienestar surge porque el alcohol reduce el cortisol, hormona del estrés, de forma selectiva y sin otros efectos secundarios inmediatos."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 4,
		"question": "Andrés acaba de tomar tres tragos y cree que está en perfectas condiciones. ¿Qué sistema del cuerpo está siendo afectado de manera silenciosa en ese momento?",
		"answers": [
			"A)  El sistema endocrino, que eleva el cortisol y prepara el cuerpo para el estrés.",
			"B)  El sistema nervioso central: el cerebelo y la corteza motora ya procesan señales con retraso, aunque la persona no perciba ese enlentecimiento subjetivamente.",
			"C)  El sistema digestivo, que prioriza la absorción del alcohol sobre la glucosa, generando hipoglucemia inmediata.",
			"D)  El sistema inmune, que redirige recursos para metabolizar el etanol y deja al cuerpo vulnerable a infecciones."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 5,
		"question": "¿Por qué la disminución del tiempo de reacción inducida por el alcohol es especialmente crítica al volante en comparación con otras actividades?",
		"answers": [
			"A)  Porque conducir activa más zonas del cerebro y el alcohol las afecta todas simultáneamente.",
			"B)  Porque en conducción, fracciones de segundo determinan si se puede evitar una colisión: un retraso de 200 ms a 90 km/h equivale a recorrer 5 metros sin reaccionar, y el alcohol puede duplicar ese retraso.",
			"C)  Porque el volante amplifica los temblores finos de mano que el alcohol produce en el sistema motor.",
			"D)  Porque la luz artificial de la noche interactúa con el efecto del alcohol sobre la pupila, creando una combinación única de riesgo."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 6,
		"question": "Andrés lleva años bebiendo a diario. ¿Cuál es el mecanismo por el que el hígado se daña de forma silenciosa y progresiva?",
		"answers": [
			"A)  El alcohol bloquea los conductos biliares, acumulando bilis hasta que inflama el tejido hepático de afuera hacia adentro.",
			"B)  El etanol y su metabolito acetaldehído generan estrés oxidativo en los hepatocitos, activando células estrelladas que depositan colágeno y reemplazan el tejido funcional con fibrosis irreversible.",
			"C)  El hígado metaboliza el alcohol priorizándolo sobre otras funciones, lo que acumula glucógeno hasta niveles tóxicos que destruyen las células.",
			"D)  El alcohol reduce la producción de bilis, lo que impide la digestión de grasas y hace que se acumulen en el hígado de forma permanente."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 7,
		"question": "Andrés tiene presión arterial elevada y el médico la relaciona con su consumo. ¿Cuál es el mecanismo cardiovascular más directo?",
		"answers": [
			"A)  El alcohol estimula la secreción de aldosterona, que retiene sodio y eleva la presión de forma aguda pero reversible.",
			"B)  El consumo crónico activa el sistema nervioso simpático de forma sostenida y altera la función endotelial, endureciendo los vasos y obligando al corazón a generar mayor presión para mantener el flujo.",
			"C)  El alcohol eleva los triglicéridos plasmáticos, que se depositan en las arterias y reducen su luz de forma proporcional al consumo.",
			"D)  El daño hepático reduce la síntesis de proteínas plasmáticas, lo que disminuye la presión oncótica y paradójicamente eleva la presión arterial."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 8,
		"question": "Andrés siente ardor gástrico casi diario. ¿Qué proceso diferencia este daño del ardor ocasional que cualquier persona puede tener?",
		"answers": [
			"A)  El ardor crónico por alcohol se produce en la parte superior del estómago, mientras que el ocasional afecta solo el esófago.",
			"B)  El consumo crónico suprime la producción de prostaglandinas protectoras, erosiona la capa mucosa del estómago y genera inflamación que con el tiempo puede derivar en úlceras sangrantes, a diferencia del ardor puntual que no implica daño estructural.",
			"C)  El ardor por alcohol ocurre porque el etanol eleva el pH gástrico, lo opuesto al ardor normal que tiene pH bajo.",
			"D)  Solo hay diferencia en intensidad, no en mecanismo: ambos se originan en el mismo proceso de hipersecreción ácida."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 9,
		"question": "¿Cuál es la diferencia clínica más importante entre el ardor estomacal ocasional y el causado por el consumo crónico de alcohol?",
		"answers": [
			"A)  El ardor crónico por alcohol tiene mayor intensidad subjetiva pero el mismo pronóstico que el ocasional.",
			"B)  El ardor crónico refleja un daño estructural acumulado en la mucosa gástrica que no se revierte con antiácidos simples y puede progresar a gastritis erosiva o úlcera péptica.",
			"C)  No existe diferencia clínica real; ambos responden igual al omeprazol.",
			"D)  El ardor ocasional es más peligroso porque aparece de forma inesperada cuando el sistema digestivo no está preparado."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 10,
		"question": "Andrés cree que beber cerveza en lugar de licor fuerte es una forma segura de evitar el daño hepático. ¿Qué hace incorrecta esa creencia?",
		"answers": [
			"A)  Es parcialmente correcta: la cerveza en volúmenes moderados no genera acetaldehído en cantidades tóxicas.",
			"B)  El daño hepático está determinado por la cantidad total de etanol consumido, no por el tipo de bebida; el hígado metaboliza el mismo compuesto independientemente de la fuente, por lo que la acumulación de daño es equivalente.",
			"C)  La cerveza daña más el hígado porque contiene lúpulo, que potencia la toxicidad del etanol.",
			"D)  La diferencia sí es relevante porque las bebidas fermentadas contienen antioxidantes que protegen parcialmente el tejido hepático."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},

	# ─────────────────────────────────────────────
	# TABACO — Fase 1: Consecuencias a Corto Plazo
	# ─────────────────────────────────────────────

	{
		"number": 11,
		"question": "Sofía dice que fumar la 'relaja'. Pero al encender un cigarrillo, ¿qué ocurre realmente en su sistema cardiovascular en los primeros 30 segundos?",
		"answers": [
			"A)  La nicotina activa receptores parasimpáticos que reducen la frecuencia cardíaca y generan relajación muscular genuina.",
			"B)  La nicotina se une a receptores nicotínicos en la médula suprarrenal, liberando adrenalina que contrae los vasos sanguíneos y eleva la presión arterial en segundos, lo opuesto a relajarse.",
			"C)  La nicotina actúa principalmente sobre el sistema digestivo, no el cardiovascular, y la relajación percibida es puramente muscular.",
			"D)  El efecto vasoconstrictor de la nicotina solo ocurre tras consumo prolongado; en consumos aislados predomina la vasodilatación."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 12,
		"question": "El humo del cigarrillo contiene monóxido de carbono. ¿Por qué este gas es particularmente dañino comparado con otros componentes del humo?",
		"answers": [
			"A)  Porque es el principal causante del cáncer de pulmón al dañar directamente el ADN de las células epiteliales.",
			"B)  Porque tiene una afinidad por la hemoglobina 200 veces mayor que el oxígeno, formando carboxihemoglobina que no puede transportar oxígeno, privando silenciosamente a todos los tejidos de su principal sustrato energético.",
			"C)  Porque se acumula en el tejido pulmonar y genera inflamación crónica que es la causa principal de la EPOC.",
			"D)  Porque reacciona con el nitrógeno del aire en los alvéolos formando compuestos tóxicos que irritan la mucosa directamente."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 13,
		"question": "Sofía siente taquicardia cada vez que fuma. ¿Por qué esa señal es una alerta médica real, no una adaptación normal del cuerpo?",
		"answers": [
			"A)  Porque cualquier aumento de frecuencia cardíaca sostenido en el tiempo produce hipertrofia ventricular que es irreversible.",
			"B)  Porque el corazón no tiene capacidad de recuperación entre episodios: cada aceleración impuesta por la nicotina acumula desgaste en el tejido cardíaco y aumenta el riesgo de arritmias, sin que exista un umbral 'seguro' de frecuencia.",
			"C)  Solo es alerta si la taquicardia supera las 120 pulsaciones por minuto de forma sostenida; por debajo de eso es una respuesta adaptativa normal.",
			"D)  La taquicardia inducida por nicotina es equivalente a la del ejercicio físico y tiene el mismo efecto cardioprotector."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 14,
		"question": "¿Por qué dejar de fumar genera síntomas físicos tan intensos si el cigarrillo no suele clasificarse como una 'droga dura'?",
		"answers": [
			"A)  Porque los síntomas son en su mayoría psicológicos y se amplifican por el hábito conductual, no por dependencia farmacológica real.",
			"B)  Porque la nicotina induce neuroadaptación: el cerebro reduce sus propios receptores colinérgicos para compensar la estimulación crónica, y al retirarla, el sistema nervioso queda en estado de hiperexcitabilidad que genera síntomas físicos genuinos.",
			"C)  Porque el tabaco contiene cientos de sustancias que permanecen en el tejido adiposo durante meses y se liberan al dejar de fumar.",
			"D)  Porque la abstinencia activa el sistema inmune, que ataca las células que se habituaron a la nicotina, generando los síntomas físicos."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 15,
		"question": "Sofía intenta pasar un día sin fumar y se pone irritable y ansiosa. ¿Qué proceso cerebral subyace a esa reacción?",
		"answers": [
			"A)  La ausencia de nicotina eleva el cortisol de forma aguda, que activa la amígdala y genera una respuesta de ansiedad similar a la del estrés postraumático.",
			"B)  Sin nicotina, los receptores colinérgicos sobrexpresados quedan sin activar, generando un estado de déficit dopaminérgico en el circuito de recompensa que el cerebro interpreta como una emergencia y traduce en irritabilidad, ansiedad y dificultad de concentración.",
			"C)  La irritabilidad se debe exclusivamente al hábito conductual: el cuerpo recuerda los momentos del día asociados al cigarrillo y genera una respuesta condicionada de frustración.",
			"D)  La falta de nicotina reduce temporalmente la serotonina en el sistema límbico, produciendo un estado depresivo leve que se confunde con ansiedad."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 16,
		"question": "Sofía se cansa fácilmente aunque no haga esfuerzo. Lleva 20 años fumando. ¿Cuál es la explicación fisiológica más completa de ese agotamiento?",
		"answers": [
			"A)  El tabaco reduce la producción de glóbulos rojos en la médula ósea, generando una anemia crónica que explica la fatiga.",
			"B)  La combinación de menor capacidad difusora pulmonar por daño alveolar y la ocupación de hemoglobina por carboxihemoglobina reduce el oxígeno disponible para los tejidos, obligando al corazón y a los músculos a trabajar más para el mismo resultado.",
			"C)  La fatiga se debe principalmente al efecto depresor del monóxido de carbono sobre el sistema nervioso central, no a problemas de oxigenación tisular.",
			"D)  El tabaco eleva el metabolismo basal a largo plazo y el cuerpo no puede sostener ese gasto energético extra, generando fatiga crónica."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 17,
		"question": "El médico le dice a Sofía que sus pulmones 'ya no se limpian solos'. ¿Qué estructura pulmonar fue destruida para que eso ocurra?",
		"answers": [
			"A)  Los macrófagos alveolares, que son las únicas células capaces de eliminar partículas extrañas del parénquima pulmonar.",
			"B)  Las células ciliadas del epitelio bronquial: el tabaco paraliza y destruye progresivamente estos cilios que barren el moco y las partículas hacia arriba, dejando los pulmones sin su mecanismo principal de limpieza.",
			"C)  Las células caliciformes, que producen el moco protector, son destruidas por el alquitrán y sin moco el pulmón no puede atrapar ni eliminar partículas.",
			"D)  El surfactante pulmonar es degradado por las toxinas del humo, colapsando progresivamente los alvéolos y reduciendo el volumen disponible para la limpieza."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 18,
		"question": "¿Por qué la EPOC causada por el tabaco no tiene cura completa aunque se deje de fumar?",
		"answers": [
			"A)  Porque los fármacos disponibles solo alivian los síntomas sin atacar la causa, y se necesitaría terapia génica para revertir el daño.",
			"B)  Porque el tejido alveolar destruido por la inflamación crónica (enfisema) no se regenera: los alvéolos dañados son remplazados por espacios aéreos agrandados e inservibles, y el tejido conectivo fibrótico no puede reconvertirse en parénquima funcional.",
			"C)  Porque el sistema inmune queda sensibilizado al humo y continúa atacando el tejido pulmonar incluso en ausencia de tabaco.",
			"D)  Porque el alquitrán acumulado en los bronquios actúa como barrera física permanente que ningún tratamiento puede disolver completamente."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 19,
		"question": "Sofía duerme 8 horas pero amanece agotada. ¿Por qué el tabaco puede comprometer la calidad del sueño aunque la duración sea adecuada?",
		"answers": [
			"A)  La nicotina eleva la temperatura corporal durante la noche, lo que impide que el cuerpo entre en las fases de sueño profundo donde ocurre la reparación celular.",
			"B)  Los pulmones dañados producen microdespertares por hipoxemia nocturna: la sangre no está bien oxigenada, el cerebro activa respuestas de alerta, se fragmenta el sueño y el cuerpo no completa los ciclos de restauración aunque las horas totales sean suficientes.",
			"C)  La nicotina tiene una vida media corta y su ausencia durante la noche genera abstinencia leve que interrumpe los ciclos de sueño REM específicamente.",
			"D)  El monóxido de carbono inhalado durante el día continúa siendo eliminado durante la noche y ese proceso metabólico interfiere con el descanso neuronal."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 20,
		"question": "Sofía fuma desde los 20 años y ahora a los 50 tiene tos productiva persistente. ¿Qué proceso crónico en sus vías respiratorias explica específicamente esa tos con flema?",
		"answers": [
			"A)  La tos con flema indica que el sistema inmune está activo y eliminando correctamente los residuos tóxicos acumulados; es una señal positiva de defensa.",
			"B)  El tabaco estimula la hiperplasia de células caliciformes y la hipersecreción de moco al tiempo que destruye los cilios que lo drenarían, generando acumulación de secreciones que la tos trata de expulsar mecánicamente como único recurso compensatorio.",
			"C)  La tos con flema en fumadores crónicos es causada principalmente por infecciones bacterianas recurrentes, no por el tabaco directamente.",
			"D)  El alquitrán se disuelve en el moco bronquial y aumenta su viscosidad, pero la tos solo aparece cuando ese proceso supera la capacidad de absorción del epitelio, lo cual ocurre después de los 50 años independientemente del tabaquismo."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},

	# ──────────────────────────────────────────────
	# MARIHUANA — Fase 1: Consecuencias a Corto Plazo
	# ──────────────────────────────────────────────

	{
		"number": 21,
		"question": "Los ojos de Lucas están siempre rojos. ¿Cuál es el mecanismo específico por el que la marihuana produce enrojecimiento ocular?",
		"answers": [
			"A)  El humo de la marihuana irrita la conjuntiva directamente, causando una respuesta inflamatoria local idéntica a la conjuntivitis alérgica.",
			"B)  El THC activa receptores cannabinoides CB1 en los músculos lisos de los vasos sanguíneos oculares, causando vasodilatación de los vasos conjuntivales que los hace visibles; este efecto ocurre incluso sin humo, con consumo oral.",
			"C)  La marihuana reduce la presión intraocular y ese cambio de presión dilata los capilares de la conjuntiva como respuesta compensatoria.",
			"D)  El enrojecimiento ocular está causado por la irritación del nervio trigémino, que comparte inervación con los vasos oculares y reactiva el enrojecimiento ante cualquier sustancia inhalada."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 22,
		"question": "Lucas dice que solo come cuando fuma. ¿Por qué el THC produce hambre aunque el cuerpo no tenga déficit calórico real?",
		"answers": [
			"A)  El THC baja la glucemia de forma aguda, lo que activa el hipotálamo para señalizar hambre como respuesta al déficit energético real.",
			"B)  El THC se une a receptores CB1 en el hipotálamo y el nervio vago, amplificando las señales de apetito y potenciando el sentido del olfato y el gusto, lo que genera un apetito disociado del estado energético real del cuerpo.",
			"C)  La marihuana eleva el metabolismo basal tan rápido que el cuerpo genera un déficit calórico genuino en minutos, lo que desencadena hambre real.",
			"D)  El efecto de hambre es exclusivamente psicológico: la asociación repetida entre consumir y comer crea una respuesta condicionada sin base fisiológica."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 23,
		"question": "Lucas tose mucho pero lo normaliza. ¿Qué proceso pulmonar distingue el daño por humo de marihuana del daño por tabaco?",
		"answers": [
			"A)  El humo de marihuana no contiene alquitrán, por lo que no daña los cilios bronquiales; solo irrita la mucosa de forma temporal y reversible.",
			"B)  Ambos humos dañan de modo similar las vías respiratorias: generan inflamación bronquial crónica, hipersecreción de moco e inactivación de cilios; la diferencia es que el fumador de marihuana suele hacer caladas más profundas y retenerlas más tiempo, lo que aumenta el depósito de partículas en zonas más profundas del pulmón.",
			"C)  La marihuana afecta los alvéolos directamente mientras que el tabaco solo daña los bronquios, por lo que los patrones de tos son clínicamente distintos.",
			"D)  El daño pulmonar por marihuana ocurre solo cuando se mezcla con tabaco; la marihuana pura no genera inflamación bronquial significativa."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 24,
		"question": "Lucas olvida cosas que pasaron hace apenas horas. ¿Qué estructura cerebral y qué mecanismo explican esa afectación de la memoria a corto plazo?",
		"answers": [
			"A)  El THC afecta la amígdala, que es la encargada de consolidar los recuerdos emocionales recientes; por eso solo olvida los eventos con carga emocional.",
			"B)  El THC activa receptores CB1 en el hipocampo, inhibiendo la potenciación a largo plazo (LTP), que es el proceso sináptico necesario para convertir experiencias recientes en memorias consolidadas.",
			"C)  El olvido de corto plazo se debe a que el THC reduce el flujo sanguíneo en la corteza prefrontal, que es la única región responsable de la memoria de trabajo.",
			"D)  La marihuana fragmenta el sueño y la consolidación de memoria ocurre solo durante el sueño REM; por eso el olvido es consecuencia indirecta del insomnio, no del THC directamente."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 25,
		"question": "¿Por qué el daño a la memoria a corto plazo por marihuana es difícil de detectar en las primeras semanas o meses de consumo frecuente?",
		"answers": [
			"A)  Porque la marihuana mejora simultáneamente la memoria visual y espacial, compensando la pérdida de memoria verbal de corto plazo.",
			"B)  Porque el deterioro se instala gradualmente y la persona lo atribuye a estrés, falta de sueño o distracción; además, el THC produce una sensación subjetiva de agudeza mental que contradice el deterioro real y retrasa la autodetección.",
			"C)  Porque el hipocampo tiene una gran reserva funcional y solo cuando se daña más del 50% de su capacidad los olvidos se vuelven perceptibles en la vida cotidiana.",
			"D)  Porque el daño real ocurre solo después de 5 años de consumo diario; antes de ese umbral los olvidos son fisiológicamente normales en cualquier persona."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 26,
		"question": "Lucas solía tocar guitarra con precisión. Ahora sus dedos no responden como antes. ¿Qué región cerebral y qué proceso afecta el THC para deteriorar la coordinación motora fina?",
		"answers": [
			"A)  El THC daña la corteza motora primaria, que es la encargada de planificar y ejecutar los movimientos voluntarios, reduciendo la velocidad de conducción nerviosa.",
			"B)  El THC activa receptores CB1 densamente distribuidos en el cerebelo, alterando la modulación de los movimientos finos y el timing motor, que son las funciones cerebelosas precisamente necesarias para tocar instrumentos.",
			"C)  La pérdida de coordinación motora es secundaria al daño en los ganglios basales, que coordinan la memoria procedimental; por eso Lucas recuerda cómo tocar pero no puede ejecutarlo.",
			"D)  El efecto motor del THC es puramente periférico: actúa en las uniones neuromusculares de los dedos, no en estructuras centrales."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 27,
		"question": "Lucas a veces siente que todos lo juzgan, especialmente después de fumar. ¿Qué circuito neurológico activa el THC para producir esa experiencia paranoide?",
		"answers": [
			"A)  El THC eleva la serotonina en la corteza cingulada anterior, que interpreta equivocadamente los estímulos sociales neutrales como amenazantes.",
			"B)  El THC en dosis altas activa de forma excesiva la amígdala, que procesa amenazas, mientras simultáneamente reduce la actividad de la corteza prefrontal, que normalmente regula y contextualiza esas respuestas de miedo, generando una percepción de amenaza sin freno racional.",
			"C)  La paranoia es una respuesta al aumento de dopamina en la corteza prefrontal que genera un estado de hiperatención a los estímulos sociales sin alterar la capacidad de evaluarlos racionalmente.",
			"D)  El THC solo genera paranoia en personas con predisposición genética al trastorno esquizofrénico; en ausencia de esa predisposición, el efecto es ansiolítico."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 28,
		"question": "Lucas cree que sus padres lo vigilan y hablan de él. ¿Cómo puede el consumo frecuente de marihuana convertir situaciones ordinarias en amenazas percibidas?",
		"answers": [
			"A)  La marihuana mejora la percepción social, lo que le permite a Lucas detectar señales sutiles que antes pasaba por alto; sus sospechas pueden tener base real.",
			"B)  El uso crónico sensibiliza los circuitos dopaminérgicos mesolímbicos, atribuyendo importancia y carga amenazante a estímulos neutros (una mirada, un silencio), un proceso llamado 'salience attribution' que subyace a la formación de creencias paranoides.",
			"C)  El efecto paranoide de la marihuana ocurre solo durante la intoxicación aguda y desaparece completamente al cesar el efecto; las sospechas persistentes de Lucas provienen de otra causa.",
			"D)  La paranoia en consumidores de marihuana es siempre proporcional a la dosis: a dosis recreativas no genera distorsión de la realidad social, solo a dosis de concentraciones de THC superiores al 20%."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 29,
		"question": "¿Por qué la paranoia inducida por marihuana puede volverse un ciclo difícil de romper incluso cuando el consumidor es consciente de que la sustancia la genera?",
		"answers": [
			"A)  Porque la paranoia inducida por THC deja una huella neurológica permanente en la amígdala que se reactiva ante cualquier nivel de estrés aunque ya no consuma.",
			"B)  Porque el aislamiento social que genera la paranoia elimina las relaciones que podrían ofrecer una perspectiva realista; ese aislamiento aumenta la ansiedad, que el consumidor alivia fumando más, lo que intensifica la paranoia y perpetúa el ciclo sin punto de quiebre interno.",
			"C)  Porque el cuerpo desarrolla tolerancia a los efectos placenteros pero no a los paranoides, por lo que se necesita más THC para el efecto deseado pero la paranoia se mantiene constante.",
			"D)  Porque los receptores CB1 implicados en la paranoia tienen mayor densidad que los relacionados con el placer, por lo que el efecto paranoide siempre supera al placentero tras el primer mes de consumo."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 30,
		"question": "Lucas lleva meses en el sótano 'esperando el momento perfecto' para volver a crear. ¿Qué efecto neurológico del cannabis crónico puede explicar esa parálisis motivacional persistente?",
		"answers": [
			"A)  La marihuana eleva los niveles de adenosina, que es un supresor del sistema de alerta, generando un estado de letargia crónica independiente del sistema de recompensa.",
			"B)  El uso crónico desensibiliza los receptores CB1 en el circuito de recompensa mesolímbico y reduce la producción basal de dopamina, generando un estado de anhedonia o síndrome amotivacional donde las actividades que antes generaban satisfacción ya no lo hacen sin el estímulo artificial del THC.",
			"C)  La parálisis creativa de Lucas es un efecto psicológico del aislamiento social, no una consecuencia neurológica directa del cannabis; con reintegración social se revertiría sin abstinencia.",
			"D)  El cannabis crónico eleva el umbral de dopamina en la corteza prefrontal exclusivamente durante el sueño, lo que impide la consolidación de metas a largo plazo pero no afecta la motivación inmediata."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},

	# ─────────────────────────────────────────────
	# COCAÍNA — Fase 1: Efectos Inmediatos
	# ─────────────────────────────────────────────

	{
		"number": 31,
		"question": "Mateo dejó de confiar en sus amigos y colegas después de meses consumiendo cocaína. ¿Cuál es el mecanismo neurológico que explica mejor esa desconfianza creciente?",
		"answers": [
			"A)  La cocaína agota la serotonina en el núcleo del rafe, generando un estado depresivo que hace que la persona interprete el mundo de forma negativa.",
			"B)  La cocaína bloquea la recaptación de dopamina y noradrenalina, sobreactivando el sistema de alerta del locus coeruleus y sensibilizando la amígdala; con el uso crónico, el cerebro queda atrapado en un estado de hipervigilancia que convierte el estado de alerta normal en sospecha patológica.",
			"C)  La desconfianza es consecuencia del aislamiento social causado por el estilo de vida, no una consecuencia neurológica directa de la cocaína sobre los circuitos de amenaza.",
			"D)  La cocaína altera los receptores de oxitocina en la corteza prefrontal, lo que reduce la capacidad de generar vínculos de confianza de forma selectiva."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 32,
		"question": "Mateo lleva días sin dormir bien pero no siente cansancio. ¿Por qué esa ausencia de fatiga percibida es una señal de peligro y no un beneficio?",
		"answers": [
			"A)  Porque el umbral de cansancio elevado hace que Mateo se exija más físicamente, acumulando daño muscular que solo se manifiesta semanas después.",
			"B)  Porque la cocaína bloquea la acumulación de adenosina, el neurotransmisor que señaliza la necesidad de descanso, pero el cuerpo sigue deteriorándose: las células neuronales no se reparan, la memoria no se consolida y el sistema inmune se debilita aunque la persona no perciba nada.",
			"C)  Porque al no sentir cansancio, Mateo consume más cocaína para mantener el estado, acelerando la tolerancia pero no causando daño fisiológico directo por la falta de sueño.",
			"D)  La ausencia de cansancio es genuinamente beneficiosa a corto plazo porque el cerebro en estado de hiperactivación cocaínica realiza funciones reparadoras equivalentes al sueño."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 33,
		"question": "¿Por qué dosis altas de cocaína pueden provocar convulsiones incluso en personas sin historial epiléptico?",
		"answers": [
			"A)  Porque la cocaína reduce el umbral de glucosa en el cerebro generando un estado de hipoglucemia aguda que desencadena crisis.",
			"B)  Porque la cocaína bloquea los canales de sodio en neuronas y al mismo tiempo eleva masivamente la dopamina y noradrenalina, generando una hiperestimulación neuronal que supera los mecanismos inhibitorios del GABA y provoca descargas eléctricas descontroladas.",
			"C)  Las convulsiones solo ocurren cuando la cocaína se mezcla con alcohol, formando cocaetileno que es el único metabolito con actividad proconvulsivante.",
			"D)  La cocaína provoca convulsiones al comprimir arterias cerebrales, generando un microinfarto transitorio que produce actividad eléctrica anormal en la corteza afectada."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 34,
		"question": "Mateo tiene dolores abdominales frecuentes que ignora. ¿Por qué el mecanismo vasoconstrictor de la cocaína es especialmente peligroso para el intestino?",
		"answers": [
			"A)  Porque el intestino delgado tiene una alta demanda de oxígeno para la absorción de nutrientes, y la vasoconstricción interrumpe ese proceso de forma aguda pero reversible.",
			"B)  Porque el intestino tiene una circulación esplácnica con poca circulación colateral: si la cocaína contrae sus arteriolas de forma intensa y prolongada, el tejido puede sufrir isquemia mesentérica que avanza rápidamente a necrosis irreversible sin dar síntomas evidentes hasta que el daño es extenso.",
			"C)  El intestino es dañado por los adulterantes que lleva la cocaína, no por el principio activo mismo; la vasoconstricción intestinal por cocaína pura es clínicamente insignificante.",
			"D)  El daño intestinal por cocaína ocurre exclusivamente cuando se consume por vía oral; por vía nasal el efecto vasoconstrictor no alcanza la circulación esplácnica en concentraciones suficientes."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 35,
		"question": "¿Por qué el daño intestinal por isquemia inducida por cocaína es considerado una emergencia médica aunque los síntomas iniciales sean leves?",
		"answers": [
			"A)  Porque el intestino tiene una gran capacidad regenerativa, pero la cocaína inhibe específicamente ese proceso de reparación celular.",
			"B)  Porque cuando el tejido intestinal muere por falta de irrigación, la barrera mucosa se perfora, permitiendo que bacterias intestinales pasen al torrente sanguíneo, lo que puede generar una sepsis que pone en riesgo la vida en horas; además, el tejido necrótico no se regenera.",
			"C)  El daño intestinal es grave solo cuando afecta más del 30% del intestino delgado; daños menores se recuperan con tratamiento médico estándar sin consecuencias permanentes.",
			"D)  La gravedad radica en que el dolor abdominal intenso lleva al paciente a urgencias donde se descubre el consumo de cocaína, lo que complica el tratamiento por interacción con los anestésicos."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 36,
		"question": "Mateo siente que su corazón a veces late muy rápido y otras parece detenerse un segundo. ¿Qué proceso electrofisiológico explica esa irregularidad?",
		"answers": [
			"A)  La cocaína agota el potasio intracelular en el miocardio, generando hipopotasemia que altera la polarización de las células cardíacas de forma predecible y dosisdependiente.",
			"B)  La cocaína bloquea los canales de sodio en el miocardio (efecto anestésico local) al tiempo que eleva la descarga simpática por exceso de catecolaminas, creando un conflicto entre conducción eléctrica enlentecida y frecuencia cardíaca acelerada que puede generar arritmias desde extrasístoles hasta fibrilación ventricular.",
			"C)  Las palpitaciones irregulares son un efecto de la ansiedad crónica inducida por la cocaína sobre el nodo sinoatrial, no un efecto electrofisiológico directo del fármaco sobre el tejido cardíaco.",
			"D)  La irregularidad del ritmo cardíaco se debe a que la cocaína aumenta la producción de adrenalina en la médula suprarrenal, que eleva la frecuencia pero no afecta la conducción, generando solo taquicardia regular."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 37,
		"question": "¿Por qué las arritmias causadas por cocaína pueden ser fatales incluso en la primera vez que ocurren, a diferencia de otras arritmias?",
		"answers": [
			"A)  Porque la primera exposición siempre produce la dosis más alta de cocaetileno, que es el metabolito con mayor cardiotoxicidad.",
			"B)  Porque la combinación de bloqueo de canales de sodio y exceso de catecolaminas puede inducir fibrilación ventricular de inicio brusco: el corazón deja de bombear sangre sin señales previas ni tiempo de respuesta, y sin desfibrilación inmediata el desenlace puede ser fatal en minutos.",
			"C)  Las arritmias fatales por cocaína solo ocurren cuando hay un defecto cardíaco previo no diagnosticado; en corazones estructuralmente normales la cocaína no genera arritmias letales en el primer consumo.",
			"D)  La letalidad en el primer consumo se debe a que el cuerpo sin tolerancia produce una respuesta inflamatoria exagerada en el pericardio que comprime el corazón."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 38,
		"question": "Mateo casi no come y ha perdido mucho peso, pero dice que 'no tiene hambre'. ¿Qué mecanismo neurológico explica la supresión del apetito por cocaína?",
		"answers": [
			"A)  La cocaína estimula los receptores de leptina en el hipotálamo, que es la hormona de la saciedad, generando un estado permanente de saciedad artificial.",
			"B)  La cocaína eleva la dopamina y la noradrenalina en el hipotálamo lateral, que es el centro del hambre: al mantener esas áreas en estado de activación crónica, el cerebro suprime la señal de hambre aunque los niveles de glucosa bajen y las reservas energéticas se agoten.",
			"C)  La supresión del apetito se debe al efecto vasoconstrictor en el estómago, que reduce la motilidad gástrica e impide que el estómago envíe las señales de vacío al cerebro que normalmente generan hambre.",
			"D)  El efecto supresor del apetito es exclusivo de la primera semana de consumo; el cuerpo desarrolla tolerancia a ese efecto y recupera el apetito normal después, por lo que la pérdida de peso extrema de Mateo debe tener otra causa."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 39,
		"question": "¿Qué consecuencias tiene para el cerebro específicamente no recibir suficiente alimentación durante meses por efecto de la cocaína?",
		"answers": [
			"A)  El cerebro tiene prioridad metabólica sobre todos los órganos, por lo que en déficit calórico el resto del cuerpo se deteriora primero; el cerebro solo se afecta en ayunos extremos superiores a tres semanas.",
			"B)  El cerebro consume el 20% de la glucosa corporal y no puede almacenar combustible; la desnutrición crónica reduce la síntesis de neurotransmisores, deteriora la mielinización de las neuronas y compromete la plasticidad sináptica, amplificando directamente el daño cognitivo ya producido por la cocaína.",
			"C)  El déficit nutricional afecta principalmente la función hepática y cardíaca, no el cerebro, que se adapta al combustible disponible cambiando a metabolismo de cuerpos cetónicos sin consecuencias cognitivas.",
			"D)  La pérdida de peso extrema activa el eje hipotálamo-hipofisario-adrenal, que eleva el cortisol y en ese estado el cerebro funciona de forma más eficiente, compensando el daño de la cocaína."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 40,
		"question": "Mateo comenzó con consumo recreativo ocasional pero en meses se volvió una necesidad diaria. ¿Qué proceso neurobiológico explica esa transición tan rápida hacia la dependencia?",
		"answers": [
			"A)  La cocaína tiene una vida media muy larga que hace que los niveles plasmáticos se acumulen progresivamente, obligando al cuerpo a compensar con más consumo para evitar los síntomas de sobredosis.",
			"B)  Cada dosis de cocaína produce picos de dopamina 3 a 5 veces superiores a cualquier recompensa natural, lo que desensibiliza los receptores del circuito de recompensa mesolímbico; con el tiempo, las actividades cotidianas no generan placer sin la sustancia, creando una dependencia funcional que escala rápidamente.",
			"C)  La dependencia a la cocaína es principalmente psicológica y conductual; no existe un sustrato neurobiológico de dependencia física comparable al del alcohol o la heroína, por lo que la transición rápida refleja rasgos de personalidad adictiva más que efectos de la sustancia.",
			"D)  La cocaína genera dependencia rápida porque daña el hígado desde las primeras dosis, reduciendo su metabolismo y haciendo que cada dosis posterior tenga un efecto más prolongado e intenso que refuerza el consumo."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	}
]

func _init(min_val: int = 1, max_val: int = 9):
	level_name = "Recovery"
	scene_path = "res://scenes/recovery/question_room.tscn"
	timeline_name = ""
	enemy_type = ""
	first_question = min_val-1
	last_question = max_val-1

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

	await get_tree().create_timer(1.0).timeout

	pergamino_anim.play("open")
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
	correct_answer = q["correct"]

	# Pregunta principal
	question_label.text = q["question"]

	
	answer1.get_node("MarginContainer/Label").text = q["answers"][0]
	answer2.get_node("MarginContainer/Label").text = q["answers"][1]
	answer3.get_node("MarginContainer/Label").text = q["answers"][2]
	answer4.get_node("MarginContainer/Label").text = q["answers"][3]

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
	await pergamino_anim.animation_finished
	await get_tree().create_timer(0.3).timeout
	# Guardamos el estado globalmente antes de irnos
	GameManager.preguntas_completadas = true
	GameManager.change_level(RecoveryState.new())
	
