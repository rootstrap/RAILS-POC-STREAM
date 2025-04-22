module Gemini
  class StreamingMockedServiceSse
    def initialize(characters = 1000, &block)
      @block = block
      @characters = characters
    end

    def call
      # Usa el thread pero asegúrate de manejar el ciclo de vida del stream
      thread = Thread.new do
        begin
          # Emite el primer evento de inicio
          @block.call({ 'text' => "Iniciando simulación de SSE..." }, nil, nil)

          # Emite los fragmentos de la historia
          story.each do |fragment|
            # Emite cada fragmento
            @block.call(mock_event(fragment), nil, nil)
            sleep 0.3
          end

          # Emite el evento de finalización
          @block.call({ 'done' => true }, nil, nil)
        rescue => e
          # Maneja los errores dentro del hilo
          @block.call({ 'error' => e.message }, nil, nil)
        end
      end

      # Asegúrate de que el hilo termine antes de continuar
      thread.join
    end

    private

    def mock_event(text)
      {
        'candidates' => [
          {
            'content' => {
              'parts' => [
                { 'text' => text }
              ]
            }
          }
        ]
      }
    end

    def story
      # Limita la longitud de la historia si es necesario
      full_story.first(@characters / 20) # Aproximando a 20 caracteres por fragmento
    end

    def full_story
      return  "SSE MOCKED\n",
      "Había una vez, ",
       "en una tierra oculta entre montañas y niebla, ",
       "un pequeño pueblo llamado Lumina. ",
       "No aparecía en los mapas, ",
       "ni era recordado por los libros de historia, ",
       "pero quienes lo conocían, ",
       "sabían que guardaba un secreto antiguo. ",
       "En el corazón de Lumina vivía Elian, ",
       "un joven aprendiz de relojero. ",
       "Pasaba sus días entre engranajes y péndulos, ",
       "ayudando a su abuelo, ",
       "el último maestro relojero del valle. ",
       "Sin embargo, ",
       "lo que realmente fascinaba a Elian ",
       "no eran los relojes, ",
       "sino la vieja torre en ruinas ",
       "que se alzaba al borde del bosque prohibido. ",
       "Los aldeanos evitaban el lugar, ",
       "contaban historias de ecos que respondían al pensamiento, ",
       "de sombras que no seguían a nadie, ",
       "y de una voz que murmuraba desde las paredes. ",
       "Una noche, ",
       "empujado por la curiosidad y el rumor de un sueño, ",
       "Elian cruzó el umbral de la torre. ",
       "Adentro, el tiempo parecía suspendido. ",
       "El polvo flotaba como constelaciones inmóviles, ",
       "y un leve zumbido vibraba en las piedras. ",
       "En el centro, ",
       "sobre un pedestal de mármol agrietado, ",
       "reposaba un extraño reloj de arena invertido. ",
       "La arena fluía hacia arriba, ",
       "como si el tiempo retrocediera en silencio. ",
       "Cuando Elian lo tocó, ",
       "una voz resonó en su mente: ",
       "“El tiempo no es una línea, ",
       "es un círculo que aún no recuerdas”. ",
       "Desde ese día, ",
       "cada vez que dormía, ",
       "soñaba con eventos que aún no ocurrían, ",
       "con personas que aún no conocía, ",
       "y con una ciudad inundada por estrellas. ",
       "La torre le reveló fragmentos del futuro, ",
       "pero con un precio. ",
       "Cuanto más visiones recibía, ",
       "más se desvanecían sus recuerdos del presente. ",
       "Comenzó a olvidar los rostros de los vecinos, ",
       "el sabor de las frutas del mercado, ",
       "incluso el nombre de su abuelo. ",
       "Preocupado, Elian buscó respuestas en los libros del taller, ",
       "en los pergaminos del templo, ",
       "y en los relatos de los ancianos. ",
       "Nadie sabía del reloj de arena, ",
       "ni de la torre antes de su nacimiento. ",
       "Un día, en uno de sus sueños, ",
       "vio una figura encapuchada que sostenía el mismo reloj de arena. ",
       "“Tu tiempo me pertenece”, dijo la figura, ",
       "“a menos que recuerdes quién eres realmente”. ",
       "Despertó con el corazón agitado ",
       "y la sensación de que algo se le escapaba entre los dedos. ",
       "Decidido a recuperar lo perdido, ",
       "regresó a la torre con una libreta vacía. ",
       "Cada día anotaba lo que recordaba, ",
       "y cada noche lo comparaba con los sueños. ",
       "Así descubrió un patrón: ",
       "la torre no robaba recuerdos, ",
       "los intercambiaba por fragmentos de futuros posibles. ",
       "Era un oráculo olvidado, ",
       "alimentado por la memoria humana. ",
       "Cuanto más fuerte era el vínculo emocional, ",
       "más valiosa era la visión obtenida. ",
       "Entonces Elian entendió su misión. ",
       "Debía recordar lo suficiente ",
       "para que su yo del futuro pudiera evitar una gran tragedia. ",
       "En los sueños vio un incendio, ",
       "la torre colapsando, ",
       "y una niña atrapada entre los escombros. ",
       "Era su hija, aún no nacida. ",
       "Y comprendió que el reloj de arena ",
       "no solo mostraba el futuro, ",
       "sino que lo llamaba, ",
       "como una semilla al brote. ",
       "Tomó la decisión de destruir la torre. ",
       "Sabía que al hacerlo, ",
       "perdería todo lo que había visto, ",
       "pero salvaría aquello que aún no existía. ",
       "Con lágrimas en los ojos, ",
       "y fuego en las manos, ",
       "Elian incendió el oráculo. ",
       "Las paredes gritaron, ",
       "las visiones danzaron como humo, ",
       "y el reloj de arena estalló, ",
       "liberando una última visión: ",
       "él, viejo, rodeado de nietos, ",
       "contando la historia de una torre que ya no existía. ",
       "Cuando todo terminó, ",
       "despertó en su taller. ",
       "Su abuelo le ofrecía pan y miel, ",
       "y aunque no recordaba nada de la torre, ",
       "una paz inexplicable lo llenaba. ",
       "Años después, ",
       "una niña de ojos dorados le preguntó: ",
       "“¿Alguna vez soñaste con el futuro?” ",
       "Elian sonrió, ",
       "y respondió: ",
       "“Tal vez sí… tal vez aún lo hago”.",
       "FIN FIN FIN."
     end
  end
end
