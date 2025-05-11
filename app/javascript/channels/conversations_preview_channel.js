import consumer from "./consumer"

document.addEventListener("turbolinks:load", () => {
  // ① user-id 요소 먼저 찾아서 존재 여부 체크
  const userEl = document.querySelector('[data-user-id]')
  if (!userEl) return  // data-user-id가 없으면 실행 중단

  const userId = userEl.dataset.userId
  // ② 그 다음에 list 요소 찾기
  const list = document.getElementById(`conversations_${userId}`)
  if (!list) return   // 채팅 목록 페이지가 아니면 구독하지 않음

  // ③ 구독 로직
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
