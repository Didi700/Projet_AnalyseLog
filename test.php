<?php
echo "PHP fonctionne !";
echo "<br>Dossier actuel : " . __DIR__;
echo "<br>Fichiers dans ce dossier : ";
echo "<pre>";
print_r(scandir(__DIR__));
echo "</pre>";
?>