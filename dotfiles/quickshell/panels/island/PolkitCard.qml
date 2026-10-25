import QtQuick
import "../../services"

// A polkit request on the island.
PasswordPromptCard {
    title: "Authentication required"
    message: Polkit.flow?.message ?? ""
    detail: Polkit.flow?.actionId ?? ""
    // After a wrong password the label turns into a warning with the attempts left.
    status: Polkit.failures > 0 ? `Wrong password, ${Polkit.attemptsLeft} ${Polkit.attemptsLeft === 1 ? "attempt" : "attempts"} left` : "Password"
    error: Polkit.failures > 0
    visibleText: Polkit.flow?.responseVisible ?? false
    buttonLabel: "Authenticate"
    onSubmitted: password => {
        if (Polkit.flow?.isResponseRequired)
            Polkit.flow.submit(password);
    }
}
