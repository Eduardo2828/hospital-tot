document.addEventListener('DOMContentLoaded', () => {
    loadNoMedics();
    document.getElementById('noMedicForm').addEventListener('submit', addNoMedic);
});

async function loadNoMedics() {
    try {
        const res = await fetch('http://localhost:5000/staff');
        const data = await res.json();
        const container = document.getElementById('no-medics-container');
        container.innerHTML = '';

        data.no_medics.forEach(emp => {
            const div = document.createElement('div');
            div.className = 'staff-card';
            div.innerHTML = `
                <h3>${emp.Nom} ${emp.Cognoms}</h3>
                <p><strong>Departament:</strong> ${emp.Departament}</p>
                <p><strong>Salari:</strong> ${emp.Salari} €</p>
                <p><strong>Telèfon:</strong> ${emp.Telefono}</p>
                <p><strong>Correu:</strong> ${emp.Correu}</p>
                <p><strong>Tasques:</strong> ${emp.Tasques || '—'}</p>
            `;
            container.appendChild(div);
        });
    } catch (error) {
        console.error('Error carregant personal no mèdic:', error);
    }
}

async function addNoMedic(e) {
    e.preventDefault();

    const data = {
        Codi: document.getElementById('Codi').value,
        Nom: document.getElementById('Nom').value,
        Cognoms: document.getElementById('Cognoms').value,
        Salari: parseFloat(document.getElementById('Salari').value),
        DataContracte: document.getElementById('DataContracte').value,
        Telefon: document.getElementById('Telefono').value,
        Correu: document.getElementById('Correu').value,
        CIF_Hospital: document.getElementById('CIF_Hospital').value,
        Tipus: 'no_medic',
        Departament: document.getElementById('Departament').value,
        Tasques: document.getElementById('Tasques').value
            .split(',')
            .map(t => t.trim())
            .filter(t => t !== '')
    };

    try {
        const res = await fetch('http://localhost:5000/staff', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });

        const result = await res.json();
        document.getElementById('missatge').textContent = result.message || result.error;

        if (res.ok) {
            document.getElementById('noMedicForm').reset();
            loadNoMedics();
        }
    } catch (err) {
        console.error('Error afegint no mèdic:', err);
        document.getElementById('missatge').textContent = 'Error afegint no mèdic';
    }
}