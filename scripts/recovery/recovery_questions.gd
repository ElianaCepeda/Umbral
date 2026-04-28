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
var first_question: int = 0 
var last_question: int = 6
var current_question_index: int = 0

var type:String
var correct_answer: int

var questions = [
	{
		"question": "Andres insiste en que puede manejar despues de beber porque \"se siente bien\". ¿Por qué esto es peligroso?",
		"answers": [
			"A)  Porque el alcohol le da demasiada confianza y acelera.",
			"B)  Porque aunque se sienta bien, su cerebro está más lento de lo normal y no puede reaccionar a tiempo ante un imprevisto.",
			"C)  Porque el alcohol lo distrae con el radio del carro.",
			"D)  Porque beber lo pone agresivo al volante."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"question": "Después de varias copas, Andrés dice que \"todo se ve un poco raro\". ¿Qué está pasando?",
		"answers": [
			"A)  Está cansado y necesita dormir.",
			"B)  El alcohol está afectando sus ojos, haciendo que no puedan enfocarse bien ni trabajar juntos.",
			"C)  Las luces del lugar están muy fuertes.",
			"D)  Lleva mucho tiempo despierto."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"question": "Andrés se siente invencible después del segundo trago y toma decisiones impulsivas. ¿Por qué el alcohol produce esa sensación?",
		"answers": [
			"A)  Porque le da energía real al cuerpo.",
			"B)  Porque engaña al cerebro haciéndole sentir felicidad falsa, pero en realidad está nublando su juicio.",
			"C)  Porque lo relaja y eso le permite pensar mejor.",
			"D)  Porque le quita el miedo de forma permanente."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"question": "Andrés acaba de tomar tres tragos y cree que está en perfectas condiciones. ¿Qué parte de su cuerpo ya está siendo afectada sin que él lo note?",
		"answers": [
			"A)  El estómago, que empieza a inflamarse.",
			"B)  El cerebro, que tarda más en procesar lo que ve y en ordenarle al cuerpo que reaccione.",
			"C)  Los pulmones, que absorben menos oxígeno.",
			"D)  La vista, que se vuelve más sensible a la luz."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"question": "¿Cuál de estas situaciones representa mejor el peligro del tiempo de reacción lento causado por el alcohol?",
		"answers": [
			"A)  Sentirse mareado al ponerse de pie.",
			"B)  No poder frenar a tiempo cuando un peatón cruza de improvisto.",
			"C)  Olvidar el nombre de un conocido en una reunión.",
			"D)  Tener sueño después de cenar."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"question": "Andrés lleva años bebiendo a diario. ¿Qué le puede estar pasando a su hígado sin que él lo note todavía?",
		"answers": [
			"A)  Nada, el hígado se acostumbra con el tiempo.",
			"B)  Se está dañando por dentro de forma silenciosa, reemplazando células sanas por tejido que ya no funciona.",
			"C)  Está trabajando el doble pero sin consecuencias.",
			"D)  Solo se daña si mezclas diferentes tipos de alcohol."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"question": "Andrés tiene la presión arterial muy alta y el médico le pregunta cuánto bebe. ¿Por qué el alcohol está relacionado con eso?",
		"answers": [
			"A)  Porque el alcohol contiene mucha sal.",
			"B)  Porque el consumo crónico de alcohol endurece y estrecha los vasos sanguíneos, forzando al corazón a bombear con más presión.",
			"C)  Porque el alcohol causa retención de líquidos que sube la presión.",
			"D)  No tiene relación, la presión alta es genética."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"question": "Andrés tiene ardor en el estómago casi todos los días pero lo ignora. ¿Qué podría estar causándolo?",
		"answers": [
			"A)  Está comiendo muy rápido últimamente.",
			"B)  El consumo constante de alcohol está irritando y desgastando el interior de su estómago con el tiempo.",
			"C)  Le cae mal la comida que sirven en las reuniones.",
			"D)  Es estrés laboral, no tiene que ver con el trago."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"question": "¿Cuál es la diferencia entre el ardor estomacal ocasional y el causado por el consumo crónico de alcohol?",
		"answers": [
			"A)  No hay diferencia, ambos se curan con antiácidos.",
			"B)  El del alcohol no es un malestar pasajero, sino el resultado de un daño acumulado en el revestimiento del estómago que se vuelve permanente.",
			"C)  El del alcohol solo ocurre al día siguiente de beber.",
			"D)  El ocasional es más grave porque aparece de sorpresa."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"question": "Sofía dice que fumar la \"relaja\". Pero justo después de encender un cigarrillo, ¿qué le pasa realmente a su cuerpo?",
		"answers": [
			"A)  Su cuerpo se relaja completamente.",
			"B)  Su presión sube casi de inmediato porque la nicotina aprieta los vasos sanguíneos.",
			"C)  Su corazón late más despacio.",
			"D)  Sus músculos se aflojan por el calor del humo."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"question": "El humo del cigarrillo contiene un gas invisible que el cuerpo no puede detectar. ¿Qué hace ese gas?",
		"answers": [
			"A)  Irrita los ojos pero no entra al cuerpo.",
			"B)  Ocupa el lugar del oxígeno en la sangre, dejando a los órganos y músculos sin lo que necesitan.",
			"C)  Sale rápido del cuerpo al exhalar.",
			"D)  Solo afecta si fumas en espacios cerrados."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"question": "Sofía siente que su corazón late más rápido cuando fuma. ¿Es eso normal o es una señal de alerta?",
		"answers": [
			"A)  Es normal, el cuerpo se adapta al tabaco.",
			"B)  Es una señal de alerta: el tabaco fuerza al corazón a trabajar más de lo que debería, desgastándolo.",
			"C)  Es por el café que toma al mismo tiempo.",
			"D)  Solo pasa en los primeros cigarrillos de vida."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"question": "¿Por qué dejar de fumar produce síntomas físicos tan intensos si el cigarrillo no es una droga \"dura\"?",
		"answers": [
			"A)  Porque los síntomas son exagerados y en realidad son psicológicos.",
			"B)  Porque la nicotina genera dependencia física real: el cerebro se reorganiza alrededor de ella y su ausencia desata una reacción física genuina.",
			"C)  Porque la persona que deja de fumar tiende a comer más y eso genera malestar.",
			"D)  Porque el tabaco contiene sustancias que permanecen en el cuerpo años después."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"question": "Sofía intenta pasar un día sin fumar y se pone muy irritable y ansiosa. ¿Por qué pasa eso?",
		"answers": [
			"A)  Porque extraña el sabor del cigarrillo.",
			"B)  Porque su cerebro ya depende de la nicotina y cuando no la recibe manda señales de alarma por todo el cuerpo.",
			"C)  Porque tiene mal carácter de base.",
			"D)  Porque está deshidratada por no fumar."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"question": "Sofía se cansa muy fácilmente aunque no haga mucho esfuerzo. Lleva 20 años fumando. ¿Puede el tabaco tener algo que ver?",
		"answers": [
			"A)  No, es simplemente la edad.",
			"B)  Sí, años de tabaco van dañando los pulmones y reducen el oxígeno que llega a todo el cuerpo, agotándolo.",
			"C)  Solo si fuma más de dos cajetillas diarias.",
			"D)  Probablemente es anemia, no tiene relación con fumar."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"question": "Sofía duerme ocho horas pero amanece agotada. ¿Por qué el tabaco puede afectar la calidad del descanso?",
		"answers": [
			"A)  Porque el cigarrillo nocturno activa el cerebro e impide el sueño profundo.",
			"B)  Porque los pulmones dañados no oxigenan bien la sangre durante la noche, y el cuerpo no se recupera aunque duerma las horas necesarias.",
			"C)  Porque la nicotina permanece activa en el cuerpo toda la noche.",
			"D)  Porque el olor del tabaco interrumpe los ciclos de sueño."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"question": "El médico le dice a Sofía que sus pulmones \"ya no se limpian solos\". ¿Qué significa eso en términos sencillos?",
		"answers": [
			"A)  Que necesita tomar más agua.",
			"B)  Que años de humo han obstruido sus vías respiratorias y cada vez le cuesta más trabajo respirar.",
			"C)  Que tiene una infección temporal que se cura con antibióticos.",
			"D)  Que respira mal por la postura que adopta al trabajar."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"question": "¿Por qué la EPOC causada por el tabaco no tiene cura completa aunque se deje de fumar?",
		"answers": [
			"A)  Porque los medicamentos actuales no son efectivos.",
			"B)  Porque el daño estructural en los pulmones ya ocurrió y el tejido destruido no se recupera, aunque dejar de fumar sí detiene el avance.",
			"C)  Porque el sistema inmune ataca los pulmones de forma autoinmune.",
			"D)  Porque el alquitrán acumulado es imposible de eliminar del cuerpo."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"question": "Los ojos de Lucas están siempre rojos. ¿Por qué la marihuana produce eso?",
		"answers": [
			"A)  Porque el humo irrita directamente la superficie del ojo.",
			"B)  Porque la marihuana hace que los vasos sanguíneos de los ojos se dilaten y se vean más.",
			"C)  Porque Lucas duerme mal y eso enrojece los ojos.",
			"D)  Porque lleva audífonos puestos muchas horas seguidas."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"question": "Lucas dice que solo come cuando fuma. ¿Por qué la marihuana produce tanta hambre?",
		"answers": [
			"A)  Porque el humo irrita el estómago y este reacciona pidiendo comida.",
			"B)  Porque activa en el cerebro los mismos receptores que regulan el apetito, generando hambre aunque el cuerpo no la necesite.",
			"C)  Porque baja el azúcar en la sangre muy rápido.",
			"D)  Porque el olor del humo despierta el apetito por asociación."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"question": "Lucas tose mucho pero lo normaliza. ¿Qué le está pasando a sus pulmones con el consumo frecuente?",
		"answers": [
			"A)  Se están fortaleciendo por el esfuerzo de toser.",
			"B)  Se están inflamando y llenando de mucosidad, dificultando cada vez más la respiración normal.",
			"C)  La tos es solo por el clima, no por fumar.",
			"D)  Es una reacción alérgica pasajera al papel del cigarrillo."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"question": "Lucas olvida cosas que pasaron hace apenas horas. ¿Con qué tiene que ver la marihuana en eso?",
		"answers": [
			"A)  Con nada, simplemente está distraído con la música.",
			"B)  El consumo frecuente afecta la parte del cerebro encargada de guardar recuerdos recientes.",
			"C)  Es porque no duerme bien, no por la marihuana.",
			"D)  Solo pasa cuando fuma demasiado en un solo día."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"question": "¿Por qué el daño a la memoria por marihuana es difícil de notar al principio?",
		"answers": [
			"A)  Porque la marihuana mejora la memoria visual y eso compensa la pérdida.",
			"B)  Porque se instala gradualmente y la persona lo atribuye al estrés, el cansancio o la falta de atención, sin relacionarlo con el consumo.",
			"C)  Porque solo afecta la memoria de largo plazo.",
			"D)  Porque el cerebro joven se recupera rápido y no lo registra."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"question": "Lucas solía tocar guitarra con precisión. Ahora sus dedos no responden como antes. ¿Puede la marihuana afectar eso?",
		"answers": [
			"A)  No, la coordinación solo se pierde con lesiones físicas.",
			"B)  Sí, la marihuana afecta la parte del cerebro que controla el equilibrio y los movimientos finos.",
			"C)  Es que no ha practicado en meses, no tiene que ver.",
			"D)  Solo afecta la coordinación en personas mayores."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"question": "Lucas a veces siente que todos lo juzgan o que algo malo va a pasar, especialmente después de fumar. ¿Por qué ocurre eso?",
		"answers": [
			"A)  Porque vive aislado y eso lo pone nervioso.",
			"B)  Porque en algunas personas la marihuana intensifica el estado de alerta hasta convertirlo en miedo y sospecha constante.",
			"C)  Porque mezcla la marihuana con cafeína.",
			"D)  Es su personalidad ansiosa, no tiene relación con el consumo."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"question": "Lucas cree que sus padres lo vigilan y hablan de él a sus espaldas. ¿Cómo puede la marihuana estar alimentando esa percepción?",
		"answers": [
			"A)  No puede, esa es una percepción basada en hechos reales.",
			"B)  La marihuana puede amplificar pensamientos negativos y convertir situaciones normales en amenazas que no existen.",
			"C)  Solo si Lucas ya tenía problemas de confianza antes de consumir.",
			"D)  Porque la marihuana lo hace más perceptivo y nota cosas que otros ignoran."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"question": "¿Por qué la paranoia inducida por marihuana puede volverse un ciclo difícil de romper?",
		"answers": [
			"A)  Porque la paranoia desaparece completamente al dejar de fumar.",
			"B)  Porque el aislamiento que genera la paranoia lleva a fumar más para calmarse, y fumar más intensifica la paranoia.",
			"C)  Porque solo afecta a personas con antecedentes familiares de ansiedad.",
			"D)  Porque los médicos no reconocen ese síntoma como relacionado con la marihuana."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"question": "Mateo dejó de confiar en sus amigos y colegas después de meses consumiendo cocaína. ¿Por qué la cocaína puede causar eso?",
		"answers": [
			"A)  Porque lo pone muy competitivo laboralmente.",
			"B)  Porque altera el cerebro llevando el estado de alerta al extremo, hasta convertirlo en sospecha de todo y todos.",
			"C)  Porque sus amigos realmente se alejaron primero.",
			"D)  Porque el estrés del trabajo lo volvió desconfiado."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"question": "Mateo lleva días sin dormir bien pero no siente cansancio. ¿Es eso una ventaja o una señal de peligro?",
		"answers": [
			"A)  Es una ventaja, puede trabajar más horas.",
			"B)  Es una señal de peligro: la cocaína engaña al cuerpo suprimiendo la sensación de cansancio, pero el daño se acumula igual.",
			"C)  Es normal si está en un periodo de mucho trabajo.",
			"D)  Solo es preocupante si lleva más de una semana sin dormir."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"question": "¿Por qué dosis altas de cocaína pueden provocar convulsiones?",
		"answers": [
			"A)  Porque el cuerpo intenta expulsar la sustancia por medio de espasmos.",
			"B)  Porque sobreestimula el cerebro de tal manera que pierde el control de las señales eléctricas que coordinan el cuerpo.",
			"C)  Porque la cocaína baja drásticamente el azúcar cerebral.",
			"D)  Porque se mezcla con el oxígeno en la sangre y produce una reacción."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"question": "Mateo tiene dolores abdominales frecuentes que ignora. ¿Cómo puede la cocaína estar relacionada con eso?",
		"answers": [
			"A)  Porque come mal desde que perdió el trabajo.",
			"B)  Porque la cocaína aprieta los vasos sanguíneos tan fuerte que algunos órganos, como el intestino, dejan de recibir suficiente sangre.",
			"C)  Porque el estrés siempre se acumula en el estómago.",
			"D)  Solo ocurre si se consume cocaína mezclada con otras sustancias."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"question": "¿Por qué el daño intestinal por cocaína es especialmente grave?",
		"answers": [
			"A)  Porque el intestino no tiene capacidad de regenerarse.",
			"B)  Porque cuando el tejido intestinal muere por falta de sangre, ese daño es irreversible y puede poner en riesgo la vida.",
			"C)  Porque el intestino es muy sensible a cualquier sustancia externa.",
			"D)  Solo es grave si se tiene una condición digestiva previa."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"question": "Mateo siente que su corazón a veces late muy rápido y otras veces parece detenerse un segundo. ¿Qué está pasando?",
		"answers": [
			"A)  Está deshidratado por no comer bien.",
			"B)  La cocaína está desregulando el ritmo del corazón, lo cual puede volverse muy peligroso.",
			"C)  Es ansiedad normal por los problemas que está viviendo.",
			"D)  Es una reacción pasajera que desaparece al descansar."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"question": "¿Por qué las arritmias causadas por cocaína pueden ser fatales incluso en la primera vez que ocurren?",
		"answers": [
			"A)  Porque el corazón de los jóvenes es más frágil.",
			"B)  Porque una arritmia severa puede detener el corazón sin previo aviso, sin dar tiempo a reaccionar.",
			"C)  Solo son fatales si el consumo duró más de un año.",
			"D)  Porque el corazón no puede recuperar su ritmo sin medicación especializada."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"question": "Mateo casi no come y ha perdido mucho peso, pero dice que \"no tiene hambre\". ¿Por qué la cocaína produce eso?",
		"answers": [
			"A)  Porque le quita el tiempo para cocinar.",
			"B)  Porque suprime la señal de hambre en el cerebro de forma tan intensa que el cuerpo se deteriora sin que la persona lo sienta.",
			"C)  Porque el estilo de vida acelerado que lleva no le permite comer.",
			"D)  Porque subió el umbral de saciedad con el tiempo."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"question": "¿Qué consecuencia tiene para el cerebro y el cuerpo no recibir suficiente alimentación por meses?",
		"answers": [
			"A)  Solo afecta el peso, no el funcionamiento del cerebro.",
			"B)  El cerebro y los órganos dejan de recibir los nutrientes que necesitan para funcionar, lo que agrava directamente los efectos del consumo y acelera el deterioro general.",
			"C)  El cuerpo aprende a funcionar con menos calorías sin consecuencias.",
			"D)  Solo es grave si la persona ya tenía bajo peso antes de consumir."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Defense"
	}
]

func _init():
	level_name = "Recovery"
	scene_path = "res://scenes/recovery/question_room.tscn"
	timeline_name = ""
	enemy_type = ""

func enter():
	print("Entrando al minijuego de recuperación...")

	if preloaded_scene:
		scene_instance = preloaded_scene.instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada en RecoveryState")
		return

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

func setup(gm_first_question: int, gm_last_question: int):
	first_question = gm_first_question
	last_question = gm_last_question
	

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
		add_points()
	else:
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
	
