app.get('/autocomp', function (req, res) {

    let body = {
        suggest: {

            AirPortCode: {
                text: req.query['q'],
                completion: {
                    field: 'Airport_code_sugg'
                }
            },
            OriginCity: {
                text: req.query['q'],
                completion: {
                    field: 'Origin_City'
                }
            },
            airportNames: {
                text: req.query['q'],
                completion: {
                    field: 'Combined'
                }
            }
        }
    } //body end

    client.search({
            index: 'vue-elastic',
            body: body,
            // type: 'characters_list'
        })
        .then(results => {
            res.send(results.suggest); //need to go to "options[0]._source.text" to display the suggestion
            console.log("AirPortCode(field: Airport_code_sugg) ====> ",
                results.suggest.AirPortCode[0].options[0].text,
                "\nOriginCity(field: Origin_City) ====>",
                results.suggest.OriginCity[0].options[0].text,
                "\nairportNames(field: Combined) ====>",
                results.suggest.airportNames[0].options[0].text);

            //  console.log(results.suggest.airportNames[0].options);
        })
        .catch(err => {
            console.log(err)
            res.send([]);
        });
});