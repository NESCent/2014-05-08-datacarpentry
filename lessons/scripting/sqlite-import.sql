.mode csv
.import plots.csv plots
.import species.csv species
.import surveys.csv surveys
.headers on
.output stdout
SELECT species.genus, species.species, plots.plot_type, surveys.*
FROM surveys
JOIN species ON surveys.species = species.species_id
JOIN plots ON surveys.plot = plots.plot_id
WHERE species.taxa = 'Rodent';
