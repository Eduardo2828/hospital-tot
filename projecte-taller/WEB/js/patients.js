async function carregarPacients() {
    const list = document.getElementById('patient-list');
    list.innerHTML = ''; 

    const res = await fetch('http://localhost:5000/patients');
    const data = await res.json();

    data.forEach(p => {
        list.innerHTML += `
            <div class="patient-card">
                <h3>${p.Nom} ${p.Cognoms}</h3>
                <p><strong>Data de Naixement:</strong> ${new Date(p.DataNaixement).toLocaleDateString()}</p>
                <p><strong>Telèfon:</strong> ${p.Telefono}</p>
                <p><strong>Correu:</strong> ${p.Correu}</p>
            </div>`;
    });
}

document.addEventListener('DOMContentLoaded', carregarPacients);

document.getElementById('patientForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const ID = document.getElementById('ID').value;
    const Nom = document.getElementById('Nom').value;
    const Cognoms = document.getElementById('Cognoms').value;
    const DataNaixement = document.getElementById('DataNaixement').value;
    const Telefono = document.getElementById('Telefono').value;
    const Correu = document.getElementById('Correu').value;
    const antecedentsText = document.getElementById('Antecedents').value;

    const Antecedents = antecedentsText
        ? antecedentsText.split(',').map(a => a.trim())
        : [];

    const response = await fetch('http://localhost:5000/patients', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            ID, Nom, Cognoms, DataNaixement, Telefono, Correu, Antecedents
        })
    });

    const result = await response.json();

    if (!response.ok) {
        alert('Error al crear pacient: ' + (result.error || result.message));
        return;
    }

    alert(result.message);
    carregarPacients();

    e.target.reset();
});
