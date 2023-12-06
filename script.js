document.getElementById('csvFileInput').addEventListener('change', function(event) {
    let file = event.target.files[0];
    Papa.parse(file, {
        complete: function(results) {
            let processedData = processCSVData(results.data);
            createDownloadLink(processedData);
        },
        header: true,
        skipEmptyLines: true
    });
});

function processCSVData(data) {
    // Define the columns to keep
    const columnsToKeep = ["First name", "Company name", "Address 1: City", "Address 1: State/County", "Email 1", "Email 2", "Email 3"];

    // Filter and process rows
    let processedRows = data.filter(row => {
        // Check for 'INACTIVE' and email presence
        if (Object.values(row).join(',').includes('INACTIVE') || !(row['Email 1'] || row['Email 2'] || row['Email 3'])) {
            return false;
        }

        // Process the 'First name' field
        row["First name"] = row["First name"].trim() === "" ? "," : ` ${row["First name"]},`;

        return true;
    }).map(row => {
        // Return only the required columns
        let newRow = {};
        columnsToKeep.forEach(col => newRow[col] = row[col] || "");
        return newRow;
    });

    // Convert the rows back to CSV format using PapaParse
    return Papa.unparse(processedRows, {
        columns: columnsToKeep
    });
}

function createDownloadLink(csvData) {
    let blob = new Blob([csvData], { type: 'text/csv' });
    let url = URL.createObjectURL(blob);

    let downloadLink = document.createElement("a");
    downloadLink.href = url;
    downloadLink.download = "processed_data.csv";
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
}

document.getElementById('downloadButton').addEventListener('click', function() {
    let csvFileInput = document.getElementById('csvFileInput');
    if (csvFileInput.files.length > 0) {
        csvFileInput.dispatchEvent(new Event('change'));
    }
});

