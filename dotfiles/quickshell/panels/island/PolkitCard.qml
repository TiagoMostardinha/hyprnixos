import QtQuick
import "../../services"

// A polkit request on the island.
PasswordPromptCard {
    id: card

    property string pending: ""

    locked: pending !== ""
    title: "Authentication required"
    message: Polkit.flow?.message ?? ""
    detail: Polkit.flow?.actionId ?? ""
    // While polkit waits for a finger it shows polkit's own message; otherwise, after a wrong password, the label
    // turns into a warning with the attempts left.
    status: !Polkit.flow?.isResponseRequired && Polkit.flow?.supplementaryMessage ? Polkit.flow.supplementaryMessage : Polkit.failures > 0 ? `Wrong password, ${Polkit.attemptsLeft} ${Polkit.attemptsLeft === 1 ? "attempt" : "attempts"} left` : "Password"
    error: Polkit.failures > 0
    visibleText: Polkit.flow?.responseVisible ?? false
    buttonLabel: "Authenticate"
    onSubmitted: password => {
        if (Polkit.flow?.isResponseRequired)
            Polkit.flow.submit(password);
        else
            card.pending = password;
    }

    Connections {
        target: Polkit.flow

        function onIsResponseRequiredChanged() {
            if (Polkit.flow.isResponseRequired && card.pending !== "") {
                Polkit.flow.submit(card.pending);
                card.pending = "";
            }
        }
    }
}
