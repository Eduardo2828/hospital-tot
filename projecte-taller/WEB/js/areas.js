document.addEventListener('DOMContentLoaded', () => {
    carregarArees();

    const form = document.getElementById('areaForm');
    if (form) {
        form.addEventListener('submit', async function (e) {
            e.preventDefault();

            const Codi = document.getElementById('Codi').value;
            const Nom = document.getElementById('Nom').value;
            const Capacitat = document.getElementById('Capacitat').value;
            const Horari = document.getElementById('Horari').value;
            const CIF_Hospital = document.getElementById('CIF_Hospital').value;

            try {
                const response = await fetch('http://localhost:5000/areas', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ Codi, Nom, Capacitat, Horari, CIF_Hospital })
                });

                const result = await response.json();
                alert(result.message || 'Àrea afegida!');

                form.reset();
                carregarArees();
            } catch (error) {
                alert('Error afegint l’àrea: ' + error.message);
                console.error(error);
            }
        });
    }
});

async function carregarArees() {
    const container = document.getElementById('area-list');
    container.innerHTML = ''; 

    try {
        const response = await fetch('http://localhost:5000/areas');
        const data = await response.json();

        data.forEach(a => {
            container.innerHTML += `
                <div class="area-card">
                    <h3>${a.Nom}</h3>
                    <p><strong>Codi:</strong> ${a.Codi}</p>
                    <p><strong>Capacitat:</strong> ${a.Capacitat}</p>
                    <p><strong>Horari:</strong> ${a.Horari}</p>
                    <p><strong>CIF Hospital:</strong> ${a.CIF_Hospital || 'N/A'}</p>
                </div>
            `;
        });

    } catch (error) {
        container.innerHTML = '<p>Error carregant les àrees.</p>';
        console.error('Error obtenint les àrees:', error);
    }
}