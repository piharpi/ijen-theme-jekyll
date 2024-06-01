document.getElementById('csvFileInput').addEventListener('change', handleFileUpload);
document.getElementById('downloadButton').addEventListener('click', handleFileDownload);

let originalData = [];
let uniqueTags = new Set();
let uniqueNotes = new Set();
let filename = '';

function handleFileUpload(event) {
    console.log('File upload event triggered');
    const file = event.target.files[0];
    if (file) {
        filename = file.name.replace('.csv', '');
        Papa.parse(file, {
            header: true,
            complete: function(results) {
                processCSV(results.data);
				showSections();
            }
        });
    }
}

function showSections() {
    document.getElementById('tags-to-exclude').classList.remove('hidden');
    document.getElementById('notes-to-exclude').classList.remove('hidden');
    document.getElementById('file-download').classList.remove('hidden');
}

function processCSV(data) {
    console.log('Processing CSV file');
    originalData = data;

    let rowCount = 0;

    data.forEach(row => {
        rowCount++;
        // Process tags
        if (row['Tag']) {
            row['Tag'].split(';').forEach(tag => uniqueTags.add(tag.replace(/"/g, '').trim()));
        }

        // Process notes
        const companyName = row['Company name'];
        if (companyName) {
            const noteMatch = companyName.match(/-\s*([A-Z\s0-9]+)$/);
            if (noteMatch) {
				let note = noteMatch[1].replace(/[()]/g, '').trim();
                if (note.length >= 3 && note !== "BUB") {
                    uniqueNotes.add(note);
                }
            }
        }
    });

    console.log(`Rows scanned: ${rowCount}`);
    console.log(`Unique tags found: ${uniqueTags.size}`);
    console.log(`Unique notes found: ${uniqueNotes.size}`);

    displayTags();
    displayNotes();
}

function displayTags() {
    console.log('Displaying tags');
    const tagsList = document.getElementById('tagsList');
    tagsList.innerHTML = '';
    Array.from(uniqueTags).sort().forEach(tag => {
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.value = tag;
        tagsList.appendChild(checkbox);
        tagsList.appendChild(document.createTextNode(tag));
        tagsList.appendChild(document.createElement('br'));
    });
}

function displayNotes() {
    console.log('Displaying notes');
    const notesList = document.getElementById('notesList');
    notesList.innerHTML = '';
    Array.from(uniqueNotes).sort().forEach(note => {
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.value = note;
        checkbox.checked = true;
        notesList.appendChild(checkbox);
        notesList.appendChild(document.createTextNode(note));
        notesList.appendChild(document.createElement('br'));
    });
}

function handleFileDownload() {
    console.log('Download button clicked');
    const selectedTags = Array.from(document.querySelectorAll('#tagsList input:checked')).map(input => input.value);
    const selectedNotes = Array.from(document.querySelectorAll('#notesList input:checked')).map(input => input.value);

    const filteredData = originalData.filter(row => {
        // Filter by tags
        if (row['Tag']) {
            const rowTags = row['Tag'].split(';').map(tag => tag.trim());
            if (rowTags.some(tag => selectedTags.includes(tag))) {
                return false;
            }
        }

        // Filter by notes
        const companyName = row['Company name'] || '';
        const firstName = row['First name'] || '';
        if (selectedNotes.some(note => companyName.includes(note) || firstName.includes(note))) {
            return false;
        }

        // Exclude rows without any email
        if (!row['Email 1'] && !row['Email 2'] && !row['Email 3']) {
            return false;
        }

        return true;
    }).map(row => {
        // Transform first name
        if (row['First name']) {
            row['First name'] = ` ${row['First name'].trim()},`;
        } else {
            row['First name'] = ',';
        }
        return row;
    });

    const columns = ['First name', 'Company name', 'Address 1: City', 'Address 1: State/County', 'Email 1', 'Email 2', 'Email 3'];
    const csvContent = Papa.unparse(filteredData, { columns });

    downloadCSV(csvContent, `${filename}_processed.csv`);
}

function downloadCSV(csv, filename) {
    console.log('Downloading CSV file');
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}
