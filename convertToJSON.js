/*
Use the Node module `convert-csv-to-json` to convert a directory of
csv files to json files.
This module doesn't properly handle commas in quoted strings, it doesn't ignore
them. It also treats quotation marks as part of the string, so a
converted string "Some String" will be "\"Some String\"" in the JSON.
Directories are read by fs.readdir()
15 March 2021 13:14
 */
const csvToJson = require('convert-csv-to-json');
const fs = require('fs');
const path = require('path');

const inputPath = "../assets/";
const outputPath = "../json/";
const delimiter = ',';

const convertToJSON = (inpath, outpath) => {
    fs.readdir(inpath, (err, files) => {
        try {
            files.forEach(file => {
                let csvFile = path.join(inpath, file);
                let jsonFile = path.join(outpath, file.replace('csv', 'json'));

                csvToJson.formatValueByType().fieldDelimiter(delimiter).generateJsonFileFromCsv(csvFile, jsonFile);
            })
        } catch (err) {
            console.log("An error has occurred: ", err);
        }
    })
};

convertToJSON(inputPath, outputPath);


