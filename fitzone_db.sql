-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 23 oct. 2025 à 14:52
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `fitzone_db`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `activer_membre` (IN `p_membre_id` INT)   BEGIN
    UPDATE inscriptions 
    SET statut = 'actif', 
        date_activation = CURDATE()
    WHERE id = p_membre_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `coachs`
--

CREATE TABLE `coachs` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `specialite` varchar(100) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `actif` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `coachs`
--

INSERT INTO `coachs` (`id`, `nom`, `prenom`, `email`, `telephone`, `specialite`, `bio`, `actif`) VALUES
(1, 'Lefebvre', 'Marc', 'marc.lefebvre@fitzone.fr', '0123456701', 'Spinning', 'Champion de cyclisme, spécialiste en cardio training haute intensité.', 1),
(2, 'Martin', 'Sophie', 'sophie.martin@fitzone.fr', '0123456702', 'Yoga & Pilates', 'Certifiée en yoga Vinyasa et Pilates depuis 8 ans.', 1),
(3, 'Bernard', 'Thomas', 'thomas.bernard@fitzone.fr', '0123456703', 'Musculation', 'Expert en renforcement musculaire et préparation physique.', 1),
(4, 'Rodriguez', 'Maria', 'maria.rodriguez@fitzone.fr', '0123456704', 'Zumba', 'Danseuse professionnelle, apporte énergie et passion.', 1),
(5, 'Moreau', 'Kevin', 'kevin.moreau@fitzone.fr', '0123456705', 'HIIT & CrossFit', 'Athlète CrossFit, spécialiste des entraînements haute intensité.', 1),
(6, 'Durand', 'Alexandre', 'alexandre.durand@fitzone.fr', '0123456706', 'Boxing', 'Champion de boxe, expert en sports de combat.', 1),
(7, 'Petit', 'Julie', 'julie.petit@fitzone.fr', '0123456707', 'Pilates', 'Instructrice certifiée Pilates et stretching.', 1),
(8, 'Laurent', 'David', 'david.laurent@fitzone.fr', '0123456708', 'CrossFit', 'Préparateur physique professionnel.', 1),
(9, 'Dubois', 'Clara', 'clara.dubois@fitzone.fr', '0123456709', 'Step & Dance', 'Chorégraphe et instructrice fitness.', 1),
(10, 'Simon', 'Léa', 'lea.simon@fitzone.fr', '0123456710', 'Dance Cardio', 'Danseuse professionnelle multi-styles.', 1);

-- --------------------------------------------------------

--
-- Structure de la table `contacts`
--

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `sujet` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `date_envoi` datetime NOT NULL,
  `traite` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `contacts`
--

INSERT INTO `contacts` (`id`, `nom`, `email`, `telephone`, `sujet`, `message`, `date_envoi`, `traite`) VALUES
(1, 'Dupont Jean', 'jean.dupont@email.fr', '0612345678', 'information', 'Je souhaite avoir plus d informations sur vos formules premium.', '2025-10-21 12:52:39', 0),
(2, 'Martin Sophie', 'sophie.martin@email.fr', '0623456789', 'cours', 'Proposez-vous des cours de yoga pour débutants ?', '2025-10-21 12:52:39', 0);

-- --------------------------------------------------------

--
-- Structure de la table `cours`
--

CREATE TABLE `cours` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `categorie` enum('cardio','renforcement','relaxation','danse') NOT NULL,
  `description` text DEFAULT NULL,
  `duree` int(11) NOT NULL COMMENT 'Durée en minutes',
  `intensite` enum('doux','modere','intense','tres_intense') NOT NULL,
  `places_max` int(11) NOT NULL,
  `coach_id` int(11) DEFAULT NULL,
  `actif` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `cours`
--

INSERT INTO `cours` (`id`, `nom`, `categorie`, `description`, `duree`, `intensite`, `places_max`, `coach_id`, `actif`) VALUES
(1, 'Spinning', 'cardio', 'Cours de vélo intense en groupe sur musique dynamique.', 45, 'intense', 20, NULL, 1),
(2, 'Boxing', 'cardio', 'Entraînement de boxe complet alliant cardio et technique.', 60, 'intense', 15, NULL, 1),
(3, 'HIIT', 'cardio', 'Entraînement par intervalles à haute intensité.', 30, 'tres_intense', 25, NULL, 1),
(4, 'CrossFit', 'renforcement', 'Programme d entraînement croisé pour développer force et endurance.', 60, 'intense', 12, NULL, 1),
(5, 'Body Pump', 'renforcement', 'Renforcement musculaire avec barres et poids sur chorégraphies.', 55, 'modere', 30, NULL, 1),
(6, 'TRX', 'renforcement', 'Entraînement en suspension pour un renforcement complet.', 45, 'intense', 15, NULL, 1),
(7, 'Yoga Vinyasa', 'relaxation', 'Enchaînements fluides de postures synchronisées avec la respiration.', 60, 'doux', 20, NULL, 1),
(8, 'Pilates', 'relaxation', 'Renforcement des muscles profonds et amélioration de la posture.', 50, 'doux', 18, NULL, 1),
(9, 'Stretching', 'relaxation', 'Séance d étirements pour améliorer la souplesse.', 30, 'doux', 25, NULL, 1),
(10, 'Zumba', 'danse', 'Danse fitness sur rythmes latins.', 60, 'modere', 35, NULL, 1),
(11, 'Dance Cardio', 'danse', 'Chorégraphies dynamiques mixant différents styles de danse.', 55, 'modere', 30, NULL, 1),
(12, 'Step', 'danse', 'Chorégraphies rythmées sur plateforme.', 50, 'modere', 25, NULL, 1);

-- --------------------------------------------------------

--
-- Structure de la table `inscriptions`
--

CREATE TABLE `inscriptions` (
  `id` int(11) NOT NULL,
  `numero_membre` varchar(20) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telephone` varchar(20) NOT NULL,
  `date_naissance` date NOT NULL,
  `sexe` enum('homme','femme') NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `code_postal` varchar(10) NOT NULL,
  `ville` varchar(100) NOT NULL,
  `formule` enum('decouverte','premium','elite') NOT NULL,
  `objectif` varchar(50) DEFAULT NULL,
  `niveau` enum('debutant','intermediaire','avance') DEFAULT NULL,
  `problemes_sante` enum('oui','non') DEFAULT 'non',
  `details_sante` text DEFAULT NULL,
  `urgence_nom` varchar(100) NOT NULL,
  `urgence_tel` varchar(20) NOT NULL,
  `comment_connu` varchar(50) DEFAULT NULL,
  `date_inscription` datetime NOT NULL,
  `statut` enum('en_attente','actif','suspendu','resilie') DEFAULT 'en_attente',
  `date_activation` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `inscriptions`
--

INSERT INTO `inscriptions` (`id`, `numero_membre`, `prenom`, `nom`, `email`, `telephone`, `date_naissance`, `sexe`, `adresse`, `code_postal`, `ville`, `formule`, `objectif`, `niveau`, `problemes_sante`, `details_sante`, `urgence_nom`, `urgence_tel`, `comment_connu`, `date_inscription`, `statut`, `date_activation`) VALUES
(1, 'FZ20256989', 'Junior', 'DUPONT', 'junior@gmail.com', '0658741520', '1995-07-14', 'homme', '14 rue vincenne', '25478', 'paris', 'premium', 'perte_poids', 'debutant', 'non', '', 'Jack', '0658741236', 'bouche_oreille', '2025-10-21 20:06:54', 'en_attente', NULL);

--
-- Déclencheurs `inscriptions`
--
DELIMITER $$
CREATE TRIGGER `before_insert_inscription` BEFORE INSERT ON `inscriptions` FOR EACH ROW BEGIN
    -- Vérifier l'âge minimum (16 ans)
    IF YEAR(CURDATE()) - YEAR(NEW.date_naissance) < 16 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L age minimum requis est de 16 ans';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `planning`
--

CREATE TABLE `planning` (
  `id` int(11) NOT NULL,
  `cours_id` int(11) NOT NULL,
  `coach_id` int(11) NOT NULL,
  `jour` enum('lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche') NOT NULL,
  `heure_debut` time NOT NULL,
  `heure_fin` time NOT NULL,
  `salle` varchar(50) DEFAULT NULL,
  `actif` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `planning`
--

INSERT INTO `planning` (`id`, `cours_id`, `coach_id`, `jour`, `heure_debut`, `heure_fin`, `salle`, `actif`) VALUES
(1, 1, 1, 'lundi', '07:00:00', '07:45:00', 'Salle Spinning', 1),
(2, 5, 3, 'lundi', '09:00:00', '09:55:00', 'Studio 1', 1),
(3, 3, 5, 'lundi', '12:00:00', '12:30:00', 'Studio 2', 1),
(4, 4, 8, 'lundi', '18:00:00', '19:00:00', 'Studio CrossFit', 1),
(5, 10, 4, 'lundi', '19:30:00', '20:30:00', 'Studio 1', 1),
(6, 7, 2, 'mardi', '07:00:00', '08:00:00', 'Studio Zen', 1),
(7, 10, 4, 'mardi', '09:00:00', '10:00:00', 'Studio 1', 1),
(8, 2, 6, 'mardi', '12:00:00', '13:00:00', 'Salle Boxing', 1),
(9, 12, 9, 'mardi', '18:00:00', '18:50:00', 'Studio 1', 1),
(10, 8, 7, 'mardi', '19:30:00', '20:20:00', 'Studio Zen', 1),
(11, 1, 1, 'mercredi', '07:00:00', '07:45:00', 'Salle Spinning', 1),
(12, 5, 3, 'mercredi', '09:00:00', '09:55:00', 'Studio 1', 1),
(13, 3, 5, 'mercredi', '12:00:00', '12:30:00', 'Studio 2', 1),
(14, 4, 8, 'mercredi', '18:00:00', '19:00:00', 'Studio CrossFit', 1),
(15, 10, 4, 'mercredi', '19:30:00', '20:30:00', 'Studio 1', 1);

-- --------------------------------------------------------

--
-- Structure de la table `reservations`
--

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL,
  `membre_id` int(11) NOT NULL,
  `planning_id` int(11) NOT NULL,
  `date_reservation` datetime NOT NULL,
  `date_cours` date NOT NULL,
  `statut` enum('confirmee','annulee','presente','absente') DEFAULT 'confirmee'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_planning_complet`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_planning_complet` (
`id` int(11)
,`cours` varchar(100)
,`categorie` enum('cardio','renforcement','relaxation','danse')
,`duree` int(11)
,`coach` varchar(201)
,`jour` enum('lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche')
,`heure_debut` time
,`heure_fin` time
,`salle` varchar(50)
,`places_max` int(11)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_statistiques_membres`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_statistiques_membres` (
`formule` enum('decouverte','premium','elite')
,`nombre_membres` bigint(21)
,`age_moyen` decimal(8,4)
);

-- --------------------------------------------------------

--
-- Structure de la vue `v_planning_complet`
--
DROP TABLE IF EXISTS `v_planning_complet`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_planning_complet`  AS SELECT `p`.`id` AS `id`, `c`.`nom` AS `cours`, `c`.`categorie` AS `categorie`, `c`.`duree` AS `duree`, concat(`co`.`prenom`,' ',`co`.`nom`) AS `coach`, `p`.`jour` AS `jour`, `p`.`heure_debut` AS `heure_debut`, `p`.`heure_fin` AS `heure_fin`, `p`.`salle` AS `salle`, `c`.`places_max` AS `places_max` FROM ((`planning` `p` join `cours` `c` on(`p`.`cours_id` = `c`.`id`)) join `coachs` `co` on(`p`.`coach_id` = `co`.`id`)) WHERE `p`.`actif` = 1 ORDER BY field(`p`.`jour`,'lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche') ASC, `p`.`heure_debut` ASC ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_statistiques_membres`
--
DROP TABLE IF EXISTS `v_statistiques_membres`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_statistiques_membres`  AS SELECT `inscriptions`.`formule` AS `formule`, count(0) AS `nombre_membres`, avg(year(curdate()) - year(`inscriptions`.`date_naissance`)) AS `age_moyen` FROM `inscriptions` WHERE `inscriptions`.`statut` = 'actif' GROUP BY `inscriptions`.`formule` ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `coachs`
--
ALTER TABLE `coachs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_actif` (`actif`);

--
-- Index pour la table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_date` (`date_envoi`);

--
-- Index pour la table `cours`
--
ALTER TABLE `cours`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_categorie` (`categorie`),
  ADD KEY `idx_actif` (`actif`);

--
-- Index pour la table `inscriptions`
--
ALTER TABLE `inscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_membre` (`numero_membre`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_numero_membre` (`numero_membre`),
  ADD KEY `idx_statut` (`statut`),
  ADD KEY `idx_formule` (`formule`);

--
-- Index pour la table `planning`
--
ALTER TABLE `planning`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cours_id` (`cours_id`),
  ADD KEY `coach_id` (`coach_id`),
  ADD KEY `idx_jour` (`jour`),
  ADD KEY `idx_actif` (`actif`);

--
-- Index pour la table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `planning_id` (`planning_id`),
  ADD KEY `idx_membre` (`membre_id`),
  ADD KEY `idx_date_cours` (`date_cours`),
  ADD KEY `idx_statut` (`statut`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `coachs`
--
ALTER TABLE `coachs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `cours`
--
ALTER TABLE `cours`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `inscriptions`
--
ALTER TABLE `inscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `planning`
--
ALTER TABLE `planning`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `planning`
--
ALTER TABLE `planning`
  ADD CONSTRAINT `planning_ibfk_1` FOREIGN KEY (`cours_id`) REFERENCES `cours` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `planning_ibfk_2` FOREIGN KEY (`coach_id`) REFERENCES `coachs` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`membre_id`) REFERENCES `inscriptions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`planning_id`) REFERENCES `planning` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
