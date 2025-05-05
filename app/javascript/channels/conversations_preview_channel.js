// app/javascript/channels/conversations_preview_channel.js
import consumer from "./consumer"

document.addEventListener("turbolinks:load", () => {
  const list = document.getElementById(
    `conversations_${document
                      .querySelector('[data-user-id]')
                      .dataset.userId}`
  )
  if (!list) return   // 채팅 목록 페이지가 아니면 구독하지 않음

  consumer.subscriptions.create(
    { channel: "ConversationsPreviewChannel" },
    {
      received(data) {
        const wrapper = document.getElementById(data.id)
        if (wrapper) wrapper.outerHTML = data.html
      }
    }
  )
})
