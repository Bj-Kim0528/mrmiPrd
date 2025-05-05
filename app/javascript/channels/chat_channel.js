// app/javascript/channels/chat_channel.js
import consumer from "./consumer"

document.addEventListener("turbolinks:load", () => {
  const container = document.getElementById("messages")
  if (!container) return

  const convId = container.dataset.conversationId
  consumer.subscriptions.create(
    { channel: "ChatChannel", conversation_id: convId },
    {
      received(data) {
        // 만약 JSON 객체라면(유저 나감 이벤트)
        if (typeof data === 'object' && data.type === 'user_left') {
          // 1) 시스템 메시지 추가
          const sys = document.createElement("div")
          sys.classList.add("message", "system-message")
          sys.innerHTML = `<em>${data.user_name}님이 나갔습니다.</em>`
          container.appendChild(sys)
          container.scrollTop = container.scrollHeight

          // 2) 입력 폼 제거
          const formWrapper = document.getElementById("new_message_form_wrapper")
          if (formWrapper) formWrapper.remove()
        } else {
          // 일반 메시지 HTML
          container.insertAdjacentHTML("beforeend", data)
          container.scrollTop = container.scrollHeight
        }
      }
    }
  )
})


