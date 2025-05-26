document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('appointment-form');
    const visitesList = document.getElementById('visites-lista');

    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        const data = {
            ID_Pacient: form.pacient.value,
            Codi_Area: form.area.value,
            CIF_Hospital: form.cif.value,
            DataHora_Inici: form.inici.value,
            DataHora_Final: form.final.value
        };

        try {
            const res = await fetch('http://localhost:5000/appointments', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });

            if (res.ok) {
                alert("Visita registrada correctament!");
                form.reset();
                carregarVisites();
            } else {
                const error = await res.json();
                alert("Error en registrar la visita: " + (error.error || res.statusText));
            }
        } catch (error) {
            alert("Error de connexió: " + error.message);
        }
    });

    async function carregarVisites() {
        visitesList.innerHTML = "Carregant visites...";

        try {
            const res = await fetch('http://localhost:5000/appointments');
            if (res.ok) {
                const visites = await res.json();
                if (visites.length === 0) {
                    visitesList.innerHTML = "<li>No hi ha visites registrades.</li>";
                    return;
                }

                visitesList.innerHTML = '';
                visites.forEach(v => {
                    const item = document.createElement('li');
                    item.textContent = `Pacient ${v.ID_Pacient}, Àrea ${v.Codi_Area}, Hospital ${v.CIF_Hospital}, Inici: ${v.DataHora_Inici}, Final: ${v.DataHora_Final}`;
                    visitesList.appendChild(item);
                });
            } else {
                visitesList.innerHTML = "Error carregant les visites.";
            }
        } catch (error) {
            visitesList.innerHTML = "Error de connexió al carregar les visites.";
        }
    }

    carregarVisites();
});