import consumer from "./consumer";

const chatChannel = consumer.subscriptions.create(
  { channel: "ChatChannel", chat_id: "123" }, // Puedes reemplazar el `123` con el `chat_id` correspondiente
  {
    connected() {
      // Se llama cuando el cliente se conecta al canal
      console.log("Conectado al canal de chat.");
    },

    disconnected() {
      // Se llama cuando el cliente se desconecta
      console.log("Desconectado del canal de chat.");
    },

    received(data) {
      // Aquí recibimos los datos enviados desde el servidor (eventos)
      console.log("Evento recibido:", data);
      
      // Puedes actualizar la interfaz de usuario con el contenido de los eventos
      const chatBox = document.getElementById("chat-box");
      chatBox.innerHTML += `<p>${data.content}</p>`;
    },

    askQuestion(question) {
      // Llamamos a ask_question en el servidor con la pregunta
      this.perform('ask_question', { question: question });
    }
  }
);

export default chatChannel;
