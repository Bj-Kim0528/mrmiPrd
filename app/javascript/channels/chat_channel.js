import consumer from "./consumer"

function styleMessage(el, currentNickname) {
  // 1) 보낸 사람 닉네임
  const sender = el.querySelector(".nickname").innerText.trim()
  const me     = sender === currentNickname

  // 2) avatar, nickname 숨김/표시
  const avatarEl   = el.querySelector("img.avatar")
  const nameEl     = el.querySelector(".nickname")
  if (avatarEl) avatarEl.style.display = me ? "none" : "block"
  nameEl.style.display = me ? "none" : "block"

  // 3) 전체 float (내꺼 = 오른쪽, 상대 = 왼쪽)
  el.style.float = me ? "right" : "left"

  // 4) 말풍선 배경 & text-color & 꼬리
  const bubble = el.querySelector(".bubble")
  if (me) {
    bubble.style.backgroundColor = "#0AA5FF"  
    bubble.style.color           = "#fff"
    bubble.style.borderRadius    = "12px 12px 12px 12px"
    // 꼬리
    bubble.style.marginLeft      = "20px"
  } else {
    bubble.style.backgroundColor = "#262626"  // 검은
    bubble.style.color           = "#fff"
    bubble.style.borderRadius    = "12px 12px 12px 12px"
    bubble.style.marginRight     = "20px"
  }
}

document.addEventListener("turbolinks:load", () => {
  const container = document.getElementById("messages")
  if (!container) return

  const currentNickname = container.dataset.currentUserNickname

  // 초기 로드된 메시지들
  container.querySelectorAll(".message").forEach(el =>
    styleMessage(el, currentNickname)
  )

  // 실시간 수신
  const convId = container.dataset.conversationId
  consumer.subscriptions.create(
    { channel: "ChatChannel", conversation_id: convId },
    {
      received(html) {
        container.insertAdjacentHTML("beforeend", html)
        styleMessage(container.lastElementChild, currentNickname)
        container.scrollTop = container.scrollHeight
      }
    }
  )
})
