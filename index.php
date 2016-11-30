<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Hello world</title>
        <script src="lib/plotly-latest.min.js"></script>
        <script src="lib/jQuery.js"></script>

    </head>

    <body>
        <script>
        var equation = "";
        function getData(int1, int2){
            var valuesJson = "";
            var mot = ($('#texteID').val());
            jQuery.ajax({
                type : 'POST',
                url : "data.php",
                data : {"formule" : equation, "int1" : int1, "int2" : int2},
                success : function(values){
                    valuesJson = values;
                },
                error : function(resultat, statut, erreur){
                },
                async:false
            });
            return valuesJson;
        }

        function texte(){
            equation = $('#texteID').val();
            var int1 = $('#int1').val();
            var int2 = $('#int2').val();
            var data=[];
            if(int1 > int2){
                data = getData(int2, int1);
            }else{
                data = getData(int1, int2);
            }
            console.log(data);
            afficher(data);
        }


        function afficher(data){
            var X=[];
            var Y=[];
            for(var i=0; i < data.length; i++){
                X.push(data[i].x);
                Y.push(data[i].y);
            }
            var trace1 = {
              x: X,
              y: Y,
              mode: 'lines',
              name:equation
            };


            var layout = {
                title:'fonction'
            };

            var fonction = [trace1];
            Plotly.newPlot('affichage', fonction, layout);

        }
        </script>
        formule : <input type="texte" id="texteID" name="formule" value = "f(x)=x"/>
        intervalle : <input type="number" id="int1" value="0"/><input type="number" id="int2" value="10"/>
        <input type="submit" value="envoyer" onclick="texte()"/>
        <div id="affichage" style="width:600px;height:450px;"></div>
    </body>
</html>
