<?php
// Set the response header to application/json
header('Content-Type: application/json');

// Allow cross-origin requests (useful for local development)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: POST, OPTIONS');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode([
        'success' => false,
        'message' => 'Only POST method is allowed'
    ]);
    exit();
}

try {
    // Get the JSON data from the request body
    $jsonData = file_get_contents('php://input');
    
    // Decode the JSON data
    $data = json_decode($jsonData, true);
    
    // Check if the JSON data is valid
    if ($data === null && json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Invalid JSON data: ' . json_last_error_msg());
    }
    
    // Add a file header comment
    $fileContent = "// filepath: c:\\Hamra's Workspace\\display routes & bus stop\\halte_data.txt\n" . 
                   json_encode($data, JSON_PRETTY_PRINT);
    
    // Write the data to the file
    $filename = 'halte_data.txt';
    $result = file_put_contents($filename, $fileContent);
    
    if ($result === false) {
        throw new Exception('Failed to write data to file');
    }
    
    // Return success response
    echo json_encode([
        'success' => true,
        'message' => 'Bus stop data saved successfully'
    ]);
    
} catch (Exception $e) {
    // Return error response
    http_response_code(500); // Internal Server Error
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>
