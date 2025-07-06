import React, { useState } from 'react'

function TemplateScreen() {
    const [addTemplateModal, showAddTemplateModal] = useState(false);
  return (
    <div>
        <div className='text-3xl font-bold pb-2'>Mobile Template</div>
        <div className='border border-gray-400 border-spacing-4 p-3'>
            <div className='text-right'>
                <button className='bg-blue-400 text-white p-2 rounded border' onClick={()=>showAddTemplateModal(true)}>New Template</button>
            </div>
    <div className="p-4">
      <table className="table-auto w-full border-collapse border border-gray-300">
        <thead>
          <tr className="bg-gray-100">
            <th className="border border-gray-300 px-4 py-2">Template Name</th>
            <th className="border border-gray-300 px-4 py-2">Template Body</th>
            <th className="border border-gray-300 px-4 py-2">Added Time</th>
            <th className="border border-gray-300 px-4 py-2">Action</th>
          </tr>
        </thead>
        <tbody>
          {/* Example Row 1 */}
          <tr>
            <td className="border border-gray-300 px-4 py-2">Welcome Template</td>
            <td className="border border-gray-300 px-4 py-2">Hello, Welcome!</td>
            <td className="border border-gray-300 px-4 py-2">2025-07-05</td>
            <td className="border border-gray-300 px-4 py-2 space-x-2">
              <button className="bg-green-500 text-white px-3 py-1 rounded">Edit</button>
              <button className="bg-red-500 text-white px-3 py-1 rounded">Delete</button>
            </td>
          </tr>

          {/* Example Row 2 */}
          <tr>
            <td className="border border-gray-300 px-4 py-2">Offer Template</td>
            <td className="border border-gray-300 px-4 py-2">Get 50% off today!</td>
            <td className="border border-gray-300 px-4 py-2">2025-07-01</td>
            <td className="border border-gray-300 px-4 py-2 space-x-2">
              <button className="bg-green-500 text-white px-3 py-1 rounded">Edit</button>
              <button className="bg-red-500 text-white px-3 py-1 rounded">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>
      
    </div>

        </div>
            {/* Add Template Modal */}
        {addTemplateModal && (
            <div className = "fixed inset-0 bg-black opacity-50 flex justify-center items-center z-50 ">
                <div className=''></div>
            </div>
        )}
    </div>
  )
}

export default TemplateScreen;