<?php
/**
 * Fichier de configuration FitZone
 * Contient tous les paramètres de connexion et configuration du site
 */

// Configuration de la base de données
define('DB_HOST', 'localhost');
define('DB_NAME', 'fitzone_db');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

// Configuration email
define('ADMIN_EMAIL', 'contact@fitzone.fr');
define('SITE_NAME', 'FitZone');

// URLs
define('SITE_URL', 'http://localhost/fitzone');
define('CONTACT_SUCCESS_URL', 'contact.html?success=1');
define('CONTACT_ERROR_URL', 'contact.html?error=1');
define('INSCRIPTION_SUCCESS_URL', 'inscription.html?success=1');
define('INSCRIPTION_ERROR_URL', 'inscription.html?error=1');

// Paramètres de sécurité
define('ENABLE_ERROR_DISPLAY', false); // Mettre à false en production

// Fuseau horaire
date_default_timezone_set('Europe/Paris');

// Gestion des erreurs
if (ENABLE_ERROR_DISPLAY) {
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
} else {
    ini_set('display_errors', 0);
    error_reporting(0);
}

/**
 * Fonction pour obtenir une connexion PDO à la base de données
 * @return PDO Objet de connexion PDO
 * @throws PDOException En cas d'erreur de connexion
 */
function getDbConnection() {
    static $pdo = null;
    
    if ($pdo === null) {
        try {
            $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
            $options = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ];
            
            $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            error_log("Erreur de connexion BDD: " . $e->getMessage());
            die("Une erreur est survenue. Veuillez réessayer plus tard.");
        }
    }
    
    return $pdo;
}

/**
 * Fonction pour nettoyer et sécuriser les données entrantes
 * @param string $data Données à nettoyer
 * @return string Données nettoyées
 */
function sanitizeInput($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

/**
 * Fonction pour valider un email
 * @param string $email Email à valider
 * @return bool True si valide, false sinon
 */
function isValidEmail($email) {
    $email = filter_var($email, FILTER_SANITIZE_EMAIL);
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}

/**
 * Fonction pour envoyer un email
 * @param string $to Destinataire
 * @param string $subject Sujet
 * @param string $message Corps du message
 * @param string $from Email expéditeur (optionnel)
 * @return bool True si envoyé, false sinon
 */
function sendEmail($to, $subject, $message, $from = ADMIN_EMAIL) {
    $headers = "From: " . $from . "\r\n";
    $headers .= "Reply-To: " . $from . "\r\n";
    $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";
    $headers .= "X-Mailer: PHP/" . phpversion();
    
    return mail($to, $subject, $message, $headers);
}

/**
 * Fonction pour générer un numéro de membre unique
 * @return string Numéro de membre
 */
function generateMembreNumber() {
    return 'FZ' . date('Y') . str_pad(rand(1, 9999), 4, '0', STR_PAD_LEFT);
}

/**
 * Fonction pour logger les erreurs
 * @param string $message Message d'erreur
 * @param string $type Type d'erreur
 */
function logError($message, $type = 'ERROR') {
    $logFile = __DIR__ . '/logs/error.log';
    $timestamp = date('Y-m-d H:i:s');
    $logMessage = "[$timestamp] [$type] $message" . PHP_EOL;
    
    // Créer le dossier logs s'il n'existe pas
    if (!file_exists(__DIR__ . '/logs')) {
        mkdir(__DIR__ . '/logs', 0755, true);
    }
    
    file_put_contents($logFile, $logMessage, FILE_APPEND);
}

/**
 * Fonction pour rediriger vers une URL
 * @param string $url URL de redirection
 */
function redirect($url) {
    header("Location: " . $url);
    exit;
}

/**
 * Fonction pour vérifier si une requête est en POST
 * @return bool True si POST, false sinon
 */
function isPostRequest() {
    return $_SERVER['REQUEST_METHOD'] === 'POST';
}

/**
 * Fonction pour obtenir un paramètre POST de manière sécurisée
 * @param string $key Clé du paramètre
 * @param mixed $default Valeur par défaut
 * @return mixed Valeur du paramètre
 */
function getPostParam($key, $default = '') {
    return isset($_POST[$key]) ? sanitizeInput($_POST[$key]) : $default;
}

/**
 * Fonction pour valider les champs obligatoires
 * @param array $fields Tableau des champs à valider
 * @param array $data Données à vérifier
 * @return array Tableau des erreurs
 */
function validateRequiredFields($fields, $data) {
    $errors = [];
    
    foreach ($fields as $field => $label) {
        if (empty($data[$field])) {
            $errors[] = "$label est obligatoire";
        }
    }
    
    return $errors;
}

/**
 * Fonction pour calculer l'âge à partir d'une date de naissance
 * @param string $dateNaissance Date de naissance (Y-m-d)
 * @return int Âge
 */
function calculateAge($dateNaissance) {
    $birthDate = new DateTime($dateNaissance);
    $today = new DateTime();
    return $today->diff($birthDate)->y;
}

/**
 * Fonction pour formater un prix
 * @param float $price Prix
 * @return string Prix formaté
 */
function formatPrice($price) {
    return number_format($price, 2, ',', ' ') . ' €';
}

/**
 * Fonction pour obtenir le nom du jour en français
 * @param string $dayEn Jour en anglais
 * @return string Jour en français
 */
function getDayFr($dayEn) {
    $days = [
        'monday' => 'lundi',
        'tuesday' => 'mardi',
        'wednesday' => 'mercredi',
        'thursday' => 'jeudi',
        'friday' => 'vendredi',
        'saturday' => 'samedi',
        'sunday' => 'dimanche'
    ];
    
    return $days[strtolower($dayEn)] ?? $dayEn;
}

// Définir les constantes de tarifs
define('TARIF_DECOUVERTE', 29);
define('TARIF_PREMIUM', 49);
define('TARIF_ELITE', 79);

// Informations de contact
define('CONTACT_ADDRESS', '123 Rue du Sport');
define('CONTACT_POSTAL', '75001');
define('CONTACT_CITY', 'Paris');
define('CONTACT_PHONE', '01 23 45 67 89');
define('CONTACT_FULL_ADDRESS', CONTACT_ADDRESS . ', ' . CONTACT_POSTAL . ' ' . CONTACT_CITY);

// Horaires
define('HORAIRES', '24h/24 - 7j/7');

// Messages
define('MSG_SUCCESS_CONTACT', 'Votre message a été envoyé avec succès !');
define('MSG_SUCCESS_INSCRIPTION', 'Votre inscription a été enregistrée avec succès !');
define('MSG_ERROR_GENERAL', 'Une erreur est survenue. Veuillez réessayer.');
define('MSG_ERROR_EMAIL', 'Adresse email invalide.');
define('MSG_ERROR_REQUIRED', 'Tous les champs obligatoires doivent être remplis.');

?>