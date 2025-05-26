document.addEventListener('DOMContentLoaded', () => {
    loadMedics();
    document.getElementById('medicForm').addEventListener('submit', addMedic);
});

async function loadMedics() {
    try {
        const res = await fetch('http://localhost:5000/staff');
        const data = await res.json();
        const medicsContainer = document.getElementById('medics-container');
        medicsContainer.innerHTML = '';

        data.medics.forEach(medic => {
            const div = document.createElement('div');
            div.className = 'staff-card';
            div.innerHTML = `
                <h3>${medic.Nom} ${medic.Cognoms}</h3>
                <p><strong>Especialitat:</strong> ${medic.Especialitat}</p>
                <p><strong>Salari:</strong> ${medic.Salari} €</p>
                <p><strong>Telèfon:</strong> ${medic.Telefono}</p>
                <p><strong>Correu:</strong> ${medic.Correu}</p>
                <p><strong>Certificats:</strong> ${medic.Certificats || '—'}</p>
            `;
            medicsContainer.appendChild(div);
        });
    } catch (error) {
        console.error('Error carregant mèdics:', error);
    }
}

async function addMedic(e) {
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
        Tipus: 'medic',
        Especialitat: document.getElementById('Especialitat').value,
        Certificats: document.getElementById('Certificats').value
            .split(',')
            .map(c => c.trim())
            .filter(c => c !== '')
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
            document.getElementById('medicForm').reset();
            loadMedics();
        }
    } catch (err) {
        console.error('Error afegint mèdic:', err);
        document.getElementById('missatge').textContent = 'Error afegint mèdic';
    }
}