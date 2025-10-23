<?php
// inscription_handler.php
// Placez ce fichier dans C:\xampp\htdocs\fitzone\

// Configuration
$success_redirect = "inscription.html?success=1";
$error_redirect = "inscription.html?error=1";

// Vérifier que la requête est en POST
if ($_SERVER["REQUEST_METHOD"] != "POST") {
    header("Location: inscription.html");
    exit;
}

// Récupération et nettoyage des données
$prenom = htmlspecialchars(trim($_POST['prenom'] ?? ''));
$nom = htmlspecialchars(trim($_POST['nom'] ?? ''));
$email = filter_var(trim($_POST['email'] ?? ''), FILTER_SANITIZE_EMAIL);
$telephone = htmlspecialchars(trim($_POST['telephone'] ?? ''));
$date_naissance = htmlspecialchars(trim($_POST['date_naissance'] ?? ''));
$sexe = htmlspecialchars(trim($_POST['sexe'] ?? ''));
$adresse = htmlspecialchars(trim($_POST['adresse'] ?? ''));
$code_postal = htmlspecialchars(trim($_POST['code_postal'] ?? ''));
$ville = htmlspecialchars(trim($_POST['ville'] ?? ''));
$formule = htmlspecialchars(trim($_POST['formule'] ?? ''));
$objectif = htmlspecialchars(trim($_POST['objectif'] ?? ''));
$niveau = htmlspecialchars(trim($_POST['niveau'] ?? ''));
$problemes_sante = htmlspecialchars(trim($_POST['problemes_sante'] ?? ''));
$details_sante = htmlspecialchars(trim($_POST['details_sante'] ?? ''));
$urgence_nom = htmlspecialchars(trim($_POST['urgence_nom'] ?? ''));
$urgence_tel = htmlspecialchars(trim($_POST['urgence_tel'] ?? ''));
$comment_connu = htmlspecialchars(trim($_POST['comment_connu'] ?? ''));

// Validation des champs obligatoires
$errors = [];

if (empty($prenom) || empty($nom)) {
    $errors[] = "Le prénom et le nom sont obligatoires";
}

if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $errors[] = "Email invalide";
}

if (empty($telephone)) {
    $errors[] = "Le téléphone est obligatoire";
}

if (empty($date_naissance)) {
    $errors[] = "La date de naissance est obligatoire";
}

if (empty($formule)) {
    $errors[] = "Veuillez choisir une formule";
}

if (empty($urgence_nom) || empty($urgence_tel)) {
    $errors[] = "Contact d'urgence obligatoire";
}

// Si erreurs, rediriger
if (!empty($errors)) {
    header("Location: " . $error_redirect);
    exit;
}

// Sauvegarder dans la base de données
if (saveInscription($prenom, $nom, $email, $telephone, $date_naissance, $sexe, 
                    $adresse, $code_postal, $ville, $formule, $objectif, $niveau, 
                    $problemes_sante, $details_sante, $urgence_nom, $urgence_tel, $comment_connu)) {
    
    // Envoyer email de confirmation (optionnel)
    sendConfirmationEmail($email, $prenom, $nom, $formule);
    
    header("Location: " . $success_redirect);
    exit;
} else {
    header("Location: " . $error_redirect);
    exit;
}

// Fonction pour sauvegarder l'inscription dans la base de données
function saveInscription($prenom, $nom, $email, $telephone, $date_naissance, $sexe, 
                        $adresse, $code_postal, $ville, $formule, $objectif, $niveau, 
                        $problemes_sante, $details_sante, $urgence_nom, $urgence_tel, $comment_connu) {
    // Configuration de la connexion
    $host = 'localhost';
    $dbname = 'fitzone_db';
    $username = 'root';
    $password = '';
    
    try {
        $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        // Générer un numéro de membre unique
        $numero_membre = generateMembreNumber();
        
        $sql = "INSERT INTO inscriptions 
                (numero_membre, prenom, nom, email, telephone, date_naissance, sexe, 
                 adresse, code_postal, ville, formule, objectif, niveau, 
                 problemes_sante, details_sante, urgence_nom, urgence_tel, 
                 comment_connu, date_inscription, statut) 
                VALUES 
                (:numero_membre, :prenom, :nom, :email, :telephone, :date_naissance, :sexe, 
                 :adresse, :code_postal, :ville, :formule, :objectif, :niveau, 
                 :problemes_sante, :details_sante, :urgence_nom, :urgence_tel, 
                 :comment_connu, NOW(), 'en_attente')";
        
        $stmt = $pdo->prepare($sql);
        
        $result = $stmt->execute([
            ':numero_membre' => $numero_membre,
            ':prenom' => $prenom,
            ':nom' => $nom,
            ':email' => $email,
            ':telephone' => $telephone,
            ':date_naissance' => $date_naissance,
            ':sexe' => $sexe,
            ':adresse' => $adresse,
            ':code_postal' => $code_postal,
            ':ville' => $ville,
            ':formule' => $formule,
            ':objectif' => $objectif,
            ':niveau' => $niveau,
            ':problemes_sante' => $problemes_sante,
            ':details_sante' => $details_sante,
            ':urgence_nom' => $urgence_nom,
            ':urgence_tel' => $urgence_tel,
            ':comment_connu' => $comment_connu
        ]);
        
        return true;
    } catch (PDOException $e) {
        error_log("Erreur BDD: " . $e->getMessage());
        return false;
    }
}

// Fonction pour générer un numéro de membre
function generateMembreNumber() {
    return 'FZ' . date('Y') . str_pad(rand(1, 9999), 4, '0', STR_PAD_LEFT);
}

// Fonction pour envoyer l'email de confirmation
function sendConfirmationEmail($email, $prenom, $nom, $formule) {
    $subject = "Bienvenue chez FitZone !";
    
    $message = "Bonjour $prenom $nom,\n\n";
    $message .= "Nous avons bien reçu votre inscription à FitZone !\n\n";
    $message .= "Formule choisie : " . ucfirst($formule) . "\n\n";
    $message .= "Pour finaliser votre inscription, merci de vous présenter à la salle avec :\n";
    $message .= "- Une pièce d'identité\n";
    $message .= "- Un RIB pour le prélèvement automatique\n";
    $message .= "- Un certificat médical de moins de 3 mois\n\n";
    $message .= "Adresse : 123 Rue du Sport, 75001 Paris\n";
    $message .= "Horaires d'accueil : Lundi-Vendredi 9h-20h, Samedi 9h-18h\n\n";
    $message .= "À très bientôt !\n\n";
    $message .= "L'équipe FitZone";
    
    $headers = "From: contact@fitzone.fr\r\n";
    $headers .= "Reply-To: contact@fitzone.fr\r\n";
    $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";
    
    return mail($email, $subject, $message, $headers);
}
?>