'use strict';

var fs = require('fs');
var _ = require('lodash');
var shelljs = require('shelljs');

function run() {

    var params = process.argv.slice(2);

    if (!_.includes(['ls', 'create', 'rm'], params[0])) {
        throw Error("FunctionCallError - Don't know what to do with '" + params[0] + "'");
    }

    try {
        var registries = JSON.parse(fs.readFileSync('registry/registry.json'));
    } catch(e) {
        fs.writeFileSync('registry/registry.json', JSON.stringify({}));
        var registries = JSON.parse(fs.readFileSync('registry/registry.json'));
    }

    switch(params[0]) {
        case 'ls':
            break;
        case 'create':
            var registryKey = params[1].replace(/\//g, '-');
            registries[registryKey] = {
                name: params[1]
            }
            fs.writeFileSync('registry/registry.json', JSON.stringify(registries));
            updateRegistryFile(registries);
            break;
        case 'rm':
            var registriesToKeep = {};
            _.forEach(registries, function(registry, registryKey) {
                if (registryKey != params[1] && registry.name != params[1]) {
                    registriesToKeep[registryKey] = registry;
                }
            });
            fs.writeFileSync('registry/registry.json', JSON.stringify(registriesToKeep));
            updateRegistryFile(registriesToKeep);
            break;
    }
}

function updateRegistryFile(registries) {
    fs.writeFileSync('registry/registry.tf', '');

    _.forEach(registries, function(registry, registryKey) {
        writeRegistry(registryKey, registry.name);
    });
}

function writeRegistry(registryKey, registryName) {
    var registryTemplate = fs.readFileSync('registry/registry.tftemplate', {encoding: 'utf8'});

    while(_.includes(registryTemplate, '{{')) {
        registryTemplate = registryTemplate.replace(/{{repository-dashed-name}}/g, registryKey);
        registryTemplate = registryTemplate.replace(/{{repository-name}}/g, registryName);
    }

    fs.appendFile('registry/registry.tf', registryTemplate + "\n\n", function (err) {
        if (err) throw err;
    });
}

run();
