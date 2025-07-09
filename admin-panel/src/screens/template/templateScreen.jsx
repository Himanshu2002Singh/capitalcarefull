import React, { useState, useEffect } from 'react';

function TemplateScreen() {
  const [addTemplateModal, showAddTemplateModal] = useState(false);
  const [selectedUploadType, setSelectedUploadType] = useState('none');
  const [templateName, setTemplateName] = useState('');
  const [templateBody, setTemplateBody] = useState('');
  const [selectedFile, setSelectedFile] = useState(null);
  const [templates, setTemplates] = useState([]);

  // 🔍 Fetch Templates
  const fetchTemplates = async () => {
    try {
      const response = await fetch('http://localhost:5000/templates'); // Update your API URL
      const data = await response.json();
      setTemplates(data.data || []);
    } catch (error) {
      console.error('Error fetching templates:', error);
    }
  };

  useEffect(() => {
    fetchTemplates();
  }, []);

  // ✅ Submit Form
  const handleSubmit = async () => {
    try {
      const formData = new FormData();
      formData.append('name', templateName);
      formData.append('description', templateBody);
      formData.append('fileType', selectedUploadType);
      if (selectedUploadType !== 'none' && selectedFile) {
        formData.append('file', selectedFile);
      }

      const response = await fetch('http://localhost:5000/template', {
        method: 'POST',
        body: formData,
      });
      const result = await response.json();
      if (result.success) {
        alert('Template created successfully!');
        fetchTemplates(); // 🔄 Refresh list
        // Reset form
        setTemplateName('');
        setTemplateBody('');
        setSelectedUploadType('none');
        setSelectedFile(null);
        showAddTemplateModal(false);
      } else {
        alert('Error creating template');
      }
    } catch (err) {
      console.error('Error uploading template:', err);
      alert('Something went wrong');
    }
  };

  return (
    <div>
      <div className='text-3xl font-bold pb-2'>Mobile Template</div>
      <div className='border border-gray-400 border-spacing-4 p-3'>
        <div className='text-right'>
          <button
            className='bg-blue-400 text-white p-2 rounded border'
            onClick={() => showAddTemplateModal(true)}
          >
            New Template
          </button>
        </div>

        {/* 🟢 Templates Table */}
        <div className="p-4">
          <table className="table-auto w-full border-collapse border border-gray-300">
            <thead>
              <tr className="bg-gray-100">
                <th className="border border-gray-300 px-4 py-2">Template Name</th>
                <th className="border border-gray-300 px-4 py-2">Template Body</th>
                <th className="border border-gray-300 px-4 py-2">File Type</th>
                <th className="border border-gray-300 px-4 py-2">Added Time</th>
              </tr>
            </thead>
            <tbody>
              {templates.map((template) => (
                <tr key={template.id}>
                  <td className="border border-gray-300 px-4 py-2">{template.name}</td>
                  <td className="border border-gray-300 px-4 py-2">{template.description}</td>
                  <td className="border border-gray-300 px-4 py-2">{template.fileType}</td>
                  <td className="border border-gray-300 px-4 py-2">{new Date(template.createdAt).toLocaleString()}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add Template Modal */}
      {addTemplateModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
          <div className="bg-white p-6 rounded-2xl shadow-2xl w-full max-w-lg relative">
            <button
              onClick={() => {
                showAddTemplateModal(false);
                setSelectedUploadType('none');
                setSelectedFile(null);
              }}
              className="absolute top-3 right-3 text-gray-600 hover:text-red-700 text-2xl font-bold"
            >
              &times;
            </button>

            <div className="border-b pb-3 mb-4">
              <h4 className="text-black font-bold text-2xl">Add Template</h4>
            </div>

            <div className="mb-4">
              <label className="block text-black font-semibold mb-2">Template Name</label>
              <input
                type="text"
                value={templateName}
                onChange={(e) => setTemplateName(e.target.value)}
                placeholder="Enter Template Name"
                className="w-full border border-gray-400 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400"
              />
            </div>

            <div className="mb-4">
              <label className="block text-black font-semibold mb-2">Template Type</label>
              <select
                className="w-full border border-gray-400 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400"
                value={selectedUploadType}
                onChange={(e) => setSelectedUploadType(e.target.value)}
              >
                <option value="none">None</option>
                <option value="image">Image</option>
                <option value="attachment">Attachment</option>
              </select>
            </div>

            {(selectedUploadType === "image" || selectedUploadType === "attachment") && (
              <div className="mb-4">
                <label className="block text-black font-semibold mb-2">Upload File</label>
                <input
                  type="file"
                  accept={selectedUploadType === 'image' ? 'image/*' : 'application/pdf'}
                  onChange={(e) => setSelectedFile(e.target.files[0])}
                  className="w-full border border-gray-400 rounded-md px-3 py-2"
                />
              </div>
            )}

            <div className="mb-4">
              <label className="block text-black font-semibold mb-2">Template Body</label>
              <textarea
                rows={4}
                value={templateBody}
                onChange={(e) => setTemplateBody(e.target.value)}
                placeholder="Enter Template Body"
                className="w-full border border-gray-400 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400"
              />
            </div>

            <div className="flex justify-end">
              <button
                className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition"
                onClick={handleSubmit}
              >
                Submit
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default TemplateScreen;
