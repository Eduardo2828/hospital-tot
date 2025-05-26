async function carregarHospitals() {
  try {
    const res = await fetch('http://localhost:5000/hospitals');
    if (!res.ok) throw new Error('Error en carregar hospitals');
    const data = await res.json();
    const list = document.getElementById('hospital-list');
    list.innerHTML = '';

    data.forEach(h => {
      list.innerHTML += `
        <div class="hospital-card">
          <h3>${h.Nom}</h3>
          <p><strong>Ubicació:</strong> ${h.Ubicacio}</p>
          <p><strong>CIF:</strong> ${h.CIF}</p>
        </div>`;
    });
  } catch (error) {
    console.error(error);
    document.getElementById('hospital-list').innerHTML = '<p class="error">No s\'han pogut carregar els hospitals.</p>';
  }
}

document.getElementById('hospitalForm').addEventListener('submit', async function(e) {
  e.preventDefault();

  const CIF = document.getElementById('CIF').value.trim();
  const Nom = document.getElementById('Nom').value.trim();
  const Ubicacio = document.getElementById('Ubicacio').value.trim();

  if (!CIF || !Nom || !Ubicacio) {
    document.getElementById('missatge').textContent = 'Omple tots els camps.';
    return;
  }

  try {
    const response = await fetch('http://localhost:5000/hospitals', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ CIF, Nom, Ubicacio })
    });

    const result = await response.json();

    if (response.ok) {
      document.getElementById('missatge').textContent = result.message;
      this.reset();
      carregarHospitals();  // recarregar llista amb el nou hospital
    } else {
      document.getElementById('missatge').textContent = 'Error: ' + (result.error || 'No s\'ha pogut afegir.');
    }
  } catch (error) {
    document.getElementById('missatge').textContent = 'Error de connexió.';
  }
});

window.addEventListener('DOMContentLoaded', carregarHospitals);