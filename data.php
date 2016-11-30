<?php
    header('Content-Type: application/json');
    if(isset($_POST['formule'])){
        echo shell_exec("c++/main " . $_POST['formule'] ." ". $_POST['int1'] ." " . $_POST['int2']);
    }
 ?>
