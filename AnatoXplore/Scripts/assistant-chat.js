(function () {
    "use strict";

    var root = document.getElementById("anxChat");
    if (!root) return;

    var panel = document.getElementById("anxChatPanel");
    var toggle = document.getElementById("anxChatToggle");
    var close = document.getElementById("anxChatClose");
    var input = document.getElementById("anxChatInput");
    var send = document.getElementById("anxChatSend");
    var messagesElement = document.getElementById("anxChatMessages");
    var conversation = [];

    function addMessage(role, text, extraClass) {
        var message = document.createElement("div");
        message.className = "anx-chat-message " + (role === "user" ? "anx-chat-user" : "anx-chat-assistant");
        if (extraClass) message.classList.add(extraClass);
        message.textContent = text;
        messagesElement.appendChild(message);
        messagesElement.scrollTop = messagesElement.scrollHeight;
        return message;
    }

    function setOpen(open) {
        panel.hidden = !open;
        toggle.setAttribute("aria-expanded", open ? "true" : "false");
        if (open) input.focus();
    }

    toggle.addEventListener("click", function () { setOpen(panel.hidden); });
    close.addEventListener("click", function () { setOpen(false); });

    async function sendMessage(event) {
        if (event) event.preventDefault();
        var text = input.value.trim();
        if (!text || send.disabled) return;

        input.value = "";
        conversation.push({ role: "user", content: text });
        addMessage("user", text);
        var waiting = addMessage("assistant", "Thinking...", "anx-chat-pending");
        send.disabled = true;

        try {
            var response = await fetch(root.getAttribute("data-endpoint"), {
                method: "POST",
                credentials: "same-origin",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify({ messages: conversation.slice(-8) })
            });
            var result = await response.json();
            waiting.remove();
            if (!response.ok) {
                addMessage("assistant", result.error || "The assistant is temporarily unavailable.");
                return;
            }
            var reply = result.reply || "I couldn't create a reply. Please try again.";
            conversation.push({ role: "assistant", content: reply });
            addMessage("assistant", reply);
            if (conversation.length > 12) conversation = conversation.slice(-12);
        } catch (error) {
            waiting.remove();
            addMessage("assistant", "I couldn't connect just now. Please try again in a moment.");
        } finally {
            send.disabled = false;
            input.focus();
        }
    }

    send.addEventListener("click", sendMessage);
    input.addEventListener("keydown", function (event) {
        if (event.key === "Enter" && !event.shiftKey) sendMessage(event);
    });
})();
