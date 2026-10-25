import QtQuick
import "../../services"

// Joining a new Wi-Fi network on the island: the polkit prompt with Wi-Fi wording.
PasswordPromptCard {
    title: "Join Wi-Fi network"
    message: `Enter the password for "${Network.joining?.name ?? ""}"`
    detail: "Wi-Fi"
    status: Network.joinError || "Password"
    error: Network.joinError !== ""
    buttonLabel: "Join"
    onSubmitted: password => {
        if (password !== "")
            Network.join(password);
    }
}
