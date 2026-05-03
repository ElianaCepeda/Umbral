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
		"question": "El enemigo Retardo representa el alargamiento del tiempo de reacción. Andrés insiste en manejar tras beber porque 'se siente bien'. ¿Por qué Retardo lo hace peligroso aunque él no lo perciba?",
		"answers": [
			"A)  El bienestar subjetivo solo dura las dos primeras copas.",
			"B)  La confianza excesiva lo lleva a ignorar señales de tráfico.",
			"C)  El cerebelo ya procesa estímulos con retraso aunque Andrés no lo sienta.",
			"D)  El alcohol solo altera la visión periférica, no el tiempo de reacción central."
		],
		"correct": 3,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 2,
		"question": "Borroso representa la pérdida de agudeza visual. Después de varias copas Andrés dice que 'todo se ve raro'. ¿Qué le hace Borroso a sus ojos?",
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
		"question": "Euforia es el enemigo que representa la falsa sensación de bienestar. Andrés se siente invencible y toma decisiones impulsivas. ¿Cómo genera Euforia esa trampa en el cerebro?",
		"answers": [
			"A)  Potencia el GABA e inunda el núcleo accumbens de dopamina, inhibiendo la corteza prefrontal.",
			"B)  Eleva endorfinas en el hipotálamo reduciendo el umbral de dolor.",
			"C)  Activa los receptores 5-HT3 generando bienestar duradero.",
			"D)  Reduce el cortisol de forma selectiva sin afectar otras funciones."
		],
		"correct": 1,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 4,
		"question": "Retardo representa el alargamiento del tiempo de reacción. Andrés cree estar en perfectas condiciones tras tres tragos. ¿Por qué Retardo es especialmente crítico al volante?",
		"answers": [
			"A)  El volante amplifica los temblores finos que el alcohol produce en la mano.",
			"B)  Conducir activa más zonas cerebrales y el alcohol las afecta todas a la vez.",
			"C)  La luz nocturna interactúa con la pupila dilatada creando un riesgo único.",
			"D)  A 90 km/h, 200 ms de retraso equivalen a 5 metros sin reaccionar, y el alcohol puede duplicar ese retraso."
		],
		"correct": 4,
		"substance": "Alcohol",
		"type": "Attack"
	},
	{
		"number": 5,
		"question": "Cirrosis destruye el hígado de Andrés en silencio. ¿Cuál es el mecanismo celular por el que Cirrosis reemplaza el tejido sano por tejido inútil?",
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
		"number": 6,
		"question": "Hipertensión sobrecarga el corazón de Andrés. El médico relaciona su presión elevada con el consumo. ¿Cómo genera Hipertensión ese daño cardiovascular crónico?",
		"answers": [
			"A)  Eleva triglicéridos que tapan las arterias y reducen su luz.",
			"B)  El consumo crónico activa el simpático de forma sostenida, endurece los vasos y fuerza al corazón a bombear con más presión.",
			"C)  Estimula la aldosterona, retiene sodio y sube la presión de forma aguda.",
			"D)  El daño hepático baja proteínas plasmáticas y paradójicamente sube la presión."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 7,
		"question": "Gastritis erosiona el estómago de Andrés con cada trago. ¿Qué hace Gastritis que la distingue del ardor ocasional de cualquier persona?",
		"answers": [
			"A)  Solo difieren en intensidad; el mecanismo de hipersecreción ácida es idéntico.",
			"B)  Gastritis erosiona la mucosa y puede derivar en úlceras sangrantes; el ardor puntual no daña estructuralmente.",
			"C)  El ardor ocasional es más grave porque el estómago no tiene tiempo de adaptarse.",
			"D)  El alcohol eleva el pH gástrico, al contrario del ardor normal que lo baja."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 8,
		"question": "Gastritis acumula daño en el estómago de Andrés. ¿Cuál es la diferencia clínica clave entre el ardor que provoca Gastritis y el ardor estomacal ocasional?",
		"answers": [
			"A)  Gastritis genera daño estructural acumulado que puede progresar a gastritis erosiva o úlcera péptica.",
			"B)  El ocasional es más peligroso porque aparece sin adaptación previa del tejido.",
			"C)  No hay diferencia real; ambos responden igual al omeprazol.",
			"D)  El crónico solo ocurre en la parte superior del estómago."
		],
		"correct": 1,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 9,
		"question": "Cirrosis destruye el hígado de Andrés en silencio. ¿Por qué el daño que provoca Cirrosis es especialmente grave comparado con el de otros órganos?",
		"answers": [
			"A)  Cuando Cirrosis destruye el hígado, las toxinas que filtrarían se acumulan en sangre y dañan en cascada todos los demás órganos.",
			"B)  Porque el hígado es el órgano más grande y su tamaño lo hace más vulnerable.",
			"C)  Porque está cerca del corazón y las toxinas pasan directo a la circulación coronaria.",
			"D)  Porque el hígado no puede regenerarse en ningún caso, ni siquiera parcialmente."
		],
		"correct": 1,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 10,
		"question": "Cirrosis daña el hígado independientemente del tipo de bebida. Andrés cree que la cerveza protege su hígado. ¿Qué hace incorrecta esa creencia frente a Cirrosis?",
		"answers": [
			"A)  Las bebidas fermentadas contienen antioxidantes que sí protegen parcialmente los hepatocitos.",
			"B)  Cirrosis responde al etanol total consumido, no al tipo de bebida; el hígado procesa el mismo compuesto sin distinción.",
			"C)  La cerveza daña más porque el lúpulo potencia la toxicidad del etanol.",
			"D)  Es parcialmente correcta: la cerveza no genera acetaldehído en cantidades tóxicas."
		],
		"correct": 2,
		"substance": "Alcohol",
		"type": "Defense"
	},
	{
		"number": 11,
		"question": "Hipertensión contrae los vasos de Sofía apenas enciende un cigarrillo. Ella dice que fumar la 'relaja'. ¿Qué hace Hipertensión en su cuerpo en los primeros 30 segundos?",
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
		"question": "Monóxido de Carbono es invisible y silencioso. ¿Por qué este enemigo es más dañino que otros componentes del humo para la oxigenación de Sofía?",
		"answers": [
			"A)  Se acumula en el pulmón y es la causa directa de la EPOC.",
			"B)  Reacciona con el nitrógeno del aire y forma compuestos que irritan la mucosa.",
			"C)  Tiene afinidad por la hemoglobina 200 veces mayor que el O₂, formando carboxihemoglobina que no transporta oxígeno.",
			"D)  Es el principal causante del cáncer porque daña el ADN de las células bronquiales."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 13,
		"question": "Taquicardia fuerza el corazón de Sofía a trabajar más cada vez que fuma. ¿Por qué Taquicardia es una alerta real y no una adaptación normal?",
		"answers": [
			"A)  Taquicardia ocurre con vasoconstricción simultánea, sobrecargando el corazón sin el beneficio adaptativo del ejercicio.",
			"B)  Es equivalente a la taquicardia del ejercicio y tiene el mismo efecto cardioprotector.",
			"C)  Solo es alerta si supera 120 ppm sostenidas; por debajo es respuesta adaptativa normal.",
			"D)  Cualquier taquicardia sostenida produce hipertrofia ventricular irreversible desde los primeros episodios."
		],
		"correct": 1,
		"substance": "Tabaco",
		"type": "Attack"
	},
	{
		"number": 14,
		"question": "Fatiga agota a Sofía aunque no haga esfuerzo. Lleva 20 años fumando. ¿Cómo genera Fatiga ese agotamiento crónico en su cuerpo?",
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
		"number": 15,
		"question": "Ansiedad aparece cuando Sofía intenta dejar de fumar. ¿Por qué genera síntomas físicos tan intensos si el cigarrillo no es una 'droga dura'?",
		"answers": [
			"A)  Los síntomas de Ansiedad son psicológicos; la dependencia farmacológica de la nicotina es comparable a la de la cafeína.",
			"B)  Ansiedad activa el sistema inmune, que ataca las células adaptadas a la nicotina.",
			"C)  La nicotina reduce la densidad de receptores colinérgicos; al retirarla, el sistema queda en hiperexcitabilidad genuina.",
			"D)  El tabaco acumula sustancias en el tejido adiposo que se liberan al dejarlo."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 16,
		"question": "Ansiedad se dispara cuando Sofía intenta pasar un día sin fumar. ¿Qué proceso cerebral explica la irritabilidad y angustia que genera Ansiedad en abstinencia?",
		"answers": [
			"A)  La ausencia de nicotina eleva el cortisol que activa la amígdala, similar al estrés postraumático.",
			"B)  La nicotina ausente reduce serotonina límbica generando un episodio depresivo leve.",
			"C)  Los receptores colinérgicos sobrexpresados quedan sin activar; el déficit dopaminérgico se siente como emergencia.",
			"D)  Es solo hábito conductual; el cuerpo recuerda los momentos del día asociados al cigarrillo."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 17,
		"question": "EPOC bloquea los pulmones de Sofía progresivamente. El médico dice que 'ya no se limpian solos'. ¿Qué estructura destruye EPOC para que eso ocurra?",
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
		"number": 18,
		"question": "EPOC destruye los pulmones de Sofía de forma irreversible. ¿Por qué no tiene cura completa aunque ella deje de fumar?",
		"answers": [
			"A)  Se necesitaría terapia génica; los fármacos solo alivian síntomas sin revertir el daño.",
			"B)  El alquitrán acumulado en los bronquios es una barrera física que no puede disolverse.",
			"C)  Los alvéolos destruidos por EPOC se reemplazan por espacios aéreos inservibles que no se regeneran aunque cese el daño.",
			"D)  El sistema inmune queda sensibilizado y continúa atacando el pulmón."
		],
		"correct": 3,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 19,
		"question": "EPOC fragmenta el descanso de Sofía aunque duerma 8 horas. ¿Cómo afecta EPOC la calidad de su sueño?",
		"answers": [
			"A)  La nicotina eleva la temperatura corporal nocturna e impide el sueño profundo.",
			"B)  Los pulmones dañados por EPOC generan hipoxemia nocturna que fragmenta los ciclos de sueño sin que Sofía lo recuerde.",
			"C)  La nicotina falta durante la noche y genera abstinencia leve que interrumpe el sueño REM.",
			"D)  El CO sigue siendo eliminado durante la noche y mantiene el metabolismo cerebral activo."
		],
		"correct": 2,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 20,
		"question": "EPOC obstruye las vías respiratorias de Sofía. A los 50 años tiene tos con flema persistente. ¿Qué proceso crónico produce EPOC en sus bronquios?",
		"answers": [
			"A)  Es causada principalmente por infecciones bacterianas recurrentes que el tabaco facilita.",
			"B)  El alquitrán aumenta la viscosidad del moco, pero la tos solo aparece tras 30 años de consumo.",
			"C)  La tos indica que el sistema inmune está activo eliminando residuos; es una señal positiva.",
			"D)  EPOC sobreestimula las células caliciformes y destruye los cilios; la tos es el único recurso compensatorio restante."
		],
		"correct": 4,
		"substance": "Tabaco",
		"type": "Defense"
	},
	{
		"number": 21,
		"question": "Conjuntivitis representa el enrojecimiento ocular que delata el consumo de Lucas. ¿Cuál es el mecanismo por el que Conjuntivitis aparece incluso sin humo?",
		"answers": [
			"A)  El humo irrita la conjuntiva directamente, igual que la conjuntivitis alérgica.",
			"B)  El nervio trigémino comparte inervación con los vasos oculares y se activa ante cualquier sustancia inhalada.",
			"C)  El THC activa receptores CB1 en los vasos conjuntivales causando vasodilatación; ocurre incluso por vía oral.",
			"D)  La marihuana baja la presión intraocular y los capilares se dilatan como compensación."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 22,
		"question": "Apetito es el enemigo que impulsa a Lucas a comer compulsivamente solo cuando fuma. ¿Cómo genera Apetito hambre sin que el cuerpo tenga déficit calórico real?",
		"answers": [
			"A)  La marihuana sube el metabolismo generando déficit calórico genuino en minutos.",
			"B)  El THC baja la glucemia activando el hipotálamo para señalizar hambre real.",
			"C)  El efecto es psicológico: la asociación repetida entre consumir y comer crea hambre condicionada.",
			"D)  El THC activa receptores CB1 en el hipotálamo y el vago, amplificando el apetito sin importar las reservas energéticas."
		],
		"correct": 4,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 23,
		"question": "Problemas respiratorios inflaman los pulmones de Lucas aunque él diga que 'no es tabaco'. ¿Qué tienen en común con el tabaco y qué los hace distintos?",
		"answers": [
			"A)  El humo de marihuana no contiene alquitrán; la irritación es temporal y reversible.",
			"B)  Problemas respiratorios solo aparecen cuando la marihuana se mezcla con tabaco.",
			"C)  Ambos inflaman bronquios e inactivan cilios; las caladas de marihuana son más profundas y llegan a zonas más distales.",
			"D)  La marihuana afecta alvéolos y el tabaco solo bronquios; por eso la progresión es distinta."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 24,
		"question": "Ideación paranoide hace que Lucas sienta que todos lo juzgan justo después de fumar. ¿Qué circuito neurológico activa para producir esa experiencia?",
		"answers": [
			"A)  Sube serotonina en la corteza cingulada, que malinterpreta estímulos sociales neutros.",
			"B)  Ideación paranoide sobreactiva la amígdala y reduce la corteza prefrontal reguladora; el miedo se amplifica sin freno racional.",
			"C)  Genera hiperatención social por exceso de dopamina prefrontal, sin alterar la evaluación racional.",
			"D)  Solo ocurre en personas con variante genética del gen COMT; en los demás el efecto es ansiolítico."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Attack"
	},
	{
		"number": 25,
		"question": "Memoria corto plazo borra los recuerdos recientes de Lucas. ¿Qué estructura y mecanismo explican el daño que produce este enemigo?",
		"answers": [
			"A)  El THC activa receptores CB1 en el hipocampo, inhibiendo la LTP necesaria para consolidar memorias recientes.",
			"B)  El THC reduce el flujo prefrontal, única región responsable de la memoria de trabajo.",
			"C)  Memoria corto plazo afecta la amígdala; por eso Lucas solo olvida eventos con carga emocional.",
			"D)  Fragmenta el sueño REM donde ocurre la consolidación; el olvido es indirecto."
		],
		"correct": 1,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 26,
		"question": "Memoria corto plazo deteriora a Lucas gradualmente. ¿Por qué su daño es tan difícil de detectar en los primeros meses de consumo frecuente?",
		"answers": [
			"A)  La marihuana mejora la memoria visual y espacial, compensando la pérdida verbal.",
			"B)  El deterioro es gradual y el THC genera sensación subjetiva de agudeza mental que contradice el daño real.",
			"C)  El daño real ocurre solo tras 5 años de consumo diario.",
			"D)  El hipocampo solo muestra olvidos perceptibles cuando más del 50% de su capacidad está comprometida."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 27,
		"question": "Desbalance motor arruina la precisión de Lucas con la guitarra. ¿Qué región cerebral afecta Desbalance motor para deteriorar la coordinación fina?",
		"answers": [
			"A)  El efecto es periférico: actúa en las uniones neuromusculares distales, no en el SNC.",
			"B)  Los ganglios basales gestionan la memoria procedimental; Lucas recuerda cómo tocar pero no puede ejecutarlo.",
			"C)  Desbalance motor activa receptores CB1 en el cerebelo, alterando el timing motor y la coordinación entre grupos musculares.",
			"D)  Daña la corteza motora primaria reduciendo la velocidad de conducción en los tractos corticoespinales."
		],
		"correct": 3,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 28,
		"question": "Ideación paranoide convierte situaciones cotidianas en amenazas para Lucas. ¿Cómo transforma este enemigo estímulos neutros en sospechas?",
		"answers": [
			"A)  Solo actúa a concentraciones de THC superiores al 20%.",
			"B)  Sensibiliza los circuitos mesolímbicos, atribuyendo carga amenazante a estímulos neutros.",
			"C)  Agudiza la percepción social; Lucas puede estar detectando señales reales que antes ignoraba.",
			"D)  Ideación paranoide solo ocurre durante la intoxicación aguda; las sospechas persistentes de Lucas son de otra causa."
		],
		"correct": 2,
		"substance": "Marihuana",
		"type": "Defense"
	},
	{
		"number": 29,
		"question": "Ideación paranoide atrapa a Lucas en un ciclo que él mismo reconoce pero no puede romper. ¿Por qué este enemigo es tan difícil de vencer?",
		"answers": [
			"A)  Los receptores CB1 paranoides son más densos que los de placer, por lo que ese efecto siempre supera al otro.",
			"B)  El cuerpo desarrolla tolerancia al placer pero no a la paranoia; más dosis siempre significa más paranoia.",
			"C)  El aislamiento que genera Ideación paranoide aumenta la ansiedad; fumar la alivia pero intensifica la paranoia, perpetuando el ciclo.",
			"D)  Deja huella permanente en la amígdala que se reactiva ante cualquier estrés aunque ya no consuma."
		],
		"correct": 3,
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
		"question": "Dependencia convierte el uso recreativo de Mateo en necesidad diaria en pocos meses. ¿Qué proceso neurobiológico explica esa transición tan rápida?",
		"answers": [
			"A)  La cocaína tiene vida media larga que acumula niveles plasmáticos que fuerzan a consumir más.",
			"B)  Dependencia desensibiliza los receptores D2 con picos de dopamina extremos; sin cocaína, nada genera placer y la dependencia escala.",
			"C)  La cocaína daña el hígado desde las primeras dosis, haciendo cada dosis siguiente más intensa.",
			"D)  Dependencia es principalmente psicológica; la transición rápida refleja personalidad adictiva."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 32,
		"question": "Ideación paranoide hace que Mateo deje de confiar en sus amigos y colegas. ¿Cuál es el mecanismo neurológico que alimenta a este enemigo en el cerebro?",
		"answers": [
			"A)  Agota la serotonina del rafe, generando un estado depresivo que distorsiona la percepción del entorno.",
			"B)  Altera los receptores de oxitocina prefrontal reduciendo la capacidad de generar confianza.",
			"C)  Es consecuencia del aislamiento social, no un efecto neurológico directo sobre los circuitos de amenaza.",
			"D)  Sobreactiva el locus coeruleus y sensibiliza la amígdala; la hipervigilancia crónica deriva en sospecha patológica."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 33,
		"question": "Insomnio suprime la fatiga de Mateo aunque lleve días sin dormir bien. ¿Por qué esa ausencia de cansancio es una señal de peligro real?",
		"answers": [
			"A)  Al no sentir cansancio consume más, acelerando tolerancia pero sin daño fisiológico directo.",
			"B)  Insomnio bloquea la adenosina del descanso; neuronas, memoria e inmunidad se siguen deteriorando aunque Mateo no sienta nada.",
			"C)  El umbral de cansancio elevado lo lleva a sobreexigirse físicamente.",
			"D)  El cerebro en hiperactivación realiza funciones reparadoras equivalentes al sueño."
		],
		"correct": 2,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 34,
		"question": "Convulsiones puede aparecer en Mateo incluso sin historial epiléptico. ¿Cuál es el mecanismo por el que dosis altas generan este enemigo?",
		"answers": [
			"A)  Convulsiones bloquea canales de sodio y dispara dopamina; supera el GABA y genera descargas eléctricas descontroladas.",
			"B)  Solo ocurre al mezclar cocaína con alcohol; el cocaetileno es el único metabolito proconvulsivante.",
			"C)  La cocaína baja la glucemia cerebral de forma aguda, desencadenando crisis por déficit energético.",
			"D)  La vasoconstricción cerebral genera microinfartos que producen actividad eléctrica anormal."
		],
		"correct": 1,
		"substance": "Cocaína",
		"type": "Attack"
	},
	{
		"number": 35,
		"question": "Necrosis destruye silenciosamente el intestino de Mateo. ¿Por qué el efecto vasoconstrictor de la cocaína es especialmente peligroso en esa zona?",
		"answers": [
			"A)  El daño solo ocurre por vía oral; por vía nasal no alcanza la circulación esplácnica.",
			"B)  El intestino tiene alta demanda de O₂; la vasoconstricción interrumpe la absorción de forma reversible.",
			"C)  El daño lo producen los adulterantes; la vasoconstricción mesentérica por cocaína pura es insignificante.",
			"D)  La circulación mesentérica tiene poca red colateral; Necrosis puede avanzar a tejido muerto irreversible sin avisar."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 36,
		"question": "Necrosis convierte un dolor abdominal leve en una emergencia de vida. ¿Por qué este enemigo es tan grave aunque los síntomas iniciales sean leves?",
		"answers": [
			"A)  Solo es emergencia cuando afecta más del 30% del intestino; daños menores se recuperan.",
			"B)  El intestino tiene alta capacidad regenerativa pero la cocaína inhibe ese proceso de reparación.",
			"C)  Necrosis perfora la barrera mucosa; bacterias pasan al torrente y generan sepsis mortal en horas, y el tejido no se recupera.",
			"D)  El dolor lleva a urgencias donde se descubre el consumo y los anestésicos interactúan."
		],
		"correct": 3,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 37,
		"question": "Arritmia desregula el corazón de Mateo, que siente latidos irregulares. ¿Qué proceso electrofisiológico desencadena Arritmia?",
		"answers": [
			"A)  Las palpitaciones son efecto de la ansiedad crónica sobre el nodo sinoatrial, no del fármaco directamente.",
			"B)  Agota el potasio intracelular del miocardio, alterando la polarización de forma predecible.",
			"C)  Solo genera taquicardia regular vía adrenalina; no afecta la conducción eléctrica.",
			"D)  Arritmia bloquea canales de sodio cardíacos y eleva catecolaminas; puede generar desde extrasístoles hasta fibrilación ventricular."
		],
		"correct": 4,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 38,
		"question": "Arritmia puede ser fatal incluso la primera vez que aparece en Mateo. ¿Por qué este enemigo es mortal sin señales previas?",
		"answers": [
			"A)  Solo son letales con defecto cardíaco previo; en corazones normales no genera arritmias fatales al inicio.",
			"B)  El primer consumo genera la mayor concentración de cocaetileno, el metabolito más cardiotóxico.",
			"C)  Arritmia puede inducir fibrilación ventricular brusca; sin desfibrilación inmediata el daño cerebral es irreversible en minutos.",
			"D)  El cuerpo sin tolerancia produce inflamación pericárdica que comprime el corazón mecánicamente."
		],
		"correct": 3,
		"substance": "Cocaína",
		"type": "Defense"
	},
	{
		"number": 39,
		"question": "Pérdida de apetito hace que Mateo casi no coma aunque su cuerpo se deteriore. ¿Qué mecanismo neurológico usa este enemigo para suprimir el hambre?",
		"answers": [
			"A)  Pérdida de apetito eleva dopamina y noradrenalina en el hipotálamo lateral, suprimiendo el hambre aunque glucemia y reservas se agoten.",
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
		"question": "Pérdida de apetito priva al cerebro de Mateo de los nutrientes que necesita durante meses. ¿Qué consecuencias tiene ese déficit sobre el cerebro específicamente?",
		"answers": [
			"A)  El cerebro se adapta a cuerpos cetónicos sin consecuencias cognitivas; el déficit afecta más hígado y corazón.",
			"B)  El cerebro tiene prioridad metabólica; el resto se deteriora primero; solo se afecta en ayunos extremos.",
			"C)  La desnutrición reduce neurotransmisores y deteriora la mielinización, amplificando el daño cognitivo de la cocaína.",
			"D)  El cortisol elevado hace el metabolismo cerebral más eficiente, compensando parte del daño."
		],
		"correct": 3,
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
	last_question = max_val-1

func enter():
	print("Entrando al minijuego de recuperación...")
		
	if preloaded_scene:
		scene_instance = preloaded_scene.instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada en RecoveryState")
		return
	page_flip = scene_instance.get_node_or_null("PageFlip")
	if page_flip:
		page_flip.play()
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
	await pergamino_anim.animation_finished
	await get_tree().create_timer(0.3).timeout
	# Guardamos el estado globalmente antes de irnos
	GameManager.preguntas_completadas = true
	GameManager.change_level(RecoveryState.new())
	
