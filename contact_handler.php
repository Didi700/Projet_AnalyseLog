<?php
// contact_handler.php
// Placez ce fichier dans C:\xampp\htdocs\fitzone\

// Configuration
$recipient_email = "contact@fitzone.fr";
$success_redirect = "contact.html?success=1";
$error_redirect = "contact.html?error=1";

// Vérifier que la requête est en POST
if ($_SERVER["REQUEST_METHOD"] != "POST") {
    header("Location: contact.html");
    exit;
}

// Récupération et nettoyage des données
$nom = htmlspecialchars(trim($_POST['nom'] ?? ''));
$email = filter_var(trim($_POST['email'] ?? ''), FILTER_SANITIZE_EMAIL);
$telephone = htmlspecialchars(trim($_POST['telephone'] ?? ''));
$sujet = htmlspecialchars(trim($_POST['sujet'] ?? ''));
$message = htmlspecialchars(trim($_POST['message'] ?? ''));

// Validation des champs obligatoires
$errors = [];

if (empty($nom)) {
    $errors[] = "Le nom est obligatoire";
}

if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $errors[] = "Email invalide";
}

if (empty($sujet)) {
    $errors[] = "Le sujet est obligatoire";
}

if (empty($message)) {
    $errors[] = "Le message est obligatoire";
}

// Si erreurs, rediriger
if (!empty($errors)) {
    header("Location: " . $error_redirect);
    exit;
}

// Sauvegarder dans la base de données
saveToDatabase($nom, $email, $telephone, $sujet, $message);

// Préparer l'email
$email_subject = "FitZone Contact - " . $sujet;
$email_body = "Nouveau message de contact FitZone\n\n";
$email_body .= "Nom: $nom\n";
$email_body .= "Email: $email\n";
$email_body .= "Téléphone: $telephone\n";
$email_body .= "Sujet: $sujet\n\n";
$email_body .= "Message:\n$message\n";

$headers = "From: $email\r\n";
$headers .= "Reply-To: $email\r\n";
$headers .= "Content-Type: text/plain; charset=UTF-8\r\n";

// Envoyer l'email (optionnel)
// mail($recipient_email, $email_subject, $email_body, $headers);

// Rediriger vers la page de succès
header("Location: " . $success_redirect);
exit;

// Fonction pour sauvegarder dans la base de données
function saveToDatabase($nom, $email, $telephone, $sujet, $message) {
    // Configuration de la connexion
    $host = 'localhost';
    $dbname = 'fitzone_db';
    $username = 'root';
    $password = '';
    
    try {
        $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $sql = "INSERT INTO contacts (nom, email, telephone, sujet, message, date_envoi) 
                VALUES (:nom, :email, :telephone, :sujet, :message, NOW())";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':nom' => $nom,
            ':email' => $email,
            ':telephone' => $telephone,
            ':sujet' => $sujet,
            ':message' => $message
        ]);
        
        return true;
    } catch (PDOException $e) {
        error_log("Erreur BDD: " . $e->getMessage());
        return false;
    }
}
?>