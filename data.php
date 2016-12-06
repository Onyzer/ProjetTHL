<?php
    header('Content-Type: application/json');
    if(isset($_POST['formule'])){
        echo shell_exec( "echo \"" . $_POST['formule'] ."\" | c++/calc ");
    }
 ?>
