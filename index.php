<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Projet THL</title>
        <script src="lib/plotly-latest.min.js"></script>
        <script src="lib/jQuery.js"></script>
    </head>

    <body>
        <script>
        var equation = "";
        function getData(){
            var valuesJson = "";
            jQuery.ajax({
                type : 'POST',
                url : "data.php",
                data : {"formule" : equation},
                success : function(values){
                    valuesJson = values;
                },
                error : function(resultat, statut, erreur){
                    console.log(erreur);
                },
                async:false
            });
            return valuesJson;
        }

        function texte(){
            equation = $('#formuleID').val();
            console.log(equation);
            var data=[];
            data = getData();
            if(!data){
                console.log("erreur");
            }else{
                console.log(data);
                afficher(data);
            }
        }


        function afficher(data){

            //var fonction_name = data[data.begin()].nom_fonction;
            //console.log(fonction_name);
            var fonction = [];
            for(var it in data){
                var X=[];
                var Y=[];
                for(var i = 1; i < data[it].length; i++){
                    //if((data[it][i].y >= - 1000)&&(data[it][i].y <=1000)){
                        X.push(data[it][i].x);
                        Y.push(data[it][i].y);
                    //}
                }
                if(data[it][0].color==''){

                }
                var trace1 = {
                  x: X,
                  y: Y,
                  mode: 'lines',
                  connectgaps : true,
                  name:it+"(x)",
                  line:{
                      color:data[it][0].color
                  }
                };
                fonction.push(trace1);
            }
            var layout = {
                title:'fonction'
            };
            /*var trace1 = {
              x: X,
              y: Y,
              mode: 'lines',
              connectgaps : true,
              name:equation
            };



            var fonction = [trace1];*/
            Plotly.newPlot('affichage', fonction, layout);

        }
        </script>
        <p>
        <TEXTAREA name="formule" id ="formuleID" rows="6    " cols="60"></TEXTAREA>
        <input type="submit" value="envoyer" onclick="texte()"/>

        <div id="affichage" style="width:600px;height:450px;"></div>
    </body>
</html>
