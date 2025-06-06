import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import axios from "axios";
import API_URL from "../../../config";
import * as XLSX from "xlsx";

const UserDetailScreen = () => {
  const { id } = useParams();
  const [user, setUser] = useState(null);
  const [lead, setLead] = useState(null);
  const [calls, setCalls] = useState([]);
  const [personNames, setPersonNames] = useState({});
  const [categorizedCalls, setCategorizedCalls] = useState({});
  const [search, setSearch] = useState(""); // For search functionality
  const [searchTerm, setSearchTerm] = useState("");
  const itemsPerPage = 50;
  const [isLoading, setIsLoading] = useState(false);

  const downloadexcel = () => {
  const filteredCalls = calls.map((call) => ({
    "Called By": personNames[call.emp_id] || "N/A",
    "Employee ID": call.emp_id || "N/A",
    "Lead ID": call.lead_id || "N/A",
    "Name": lead?.name || "N/A", // from lead state
    "Phone": call.number || "N/A",
    "Remark": call.remark || "N/A",
    "Created At": new Date(call.createdAt).toLocaleString("en-IN", {
      dateStyle: "medium",
      timeStyle: "short",
    }),
  }));

  const ws = XLSX.utils.json_to_sheet(filteredCalls);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, "Calls");
  XLSX.writeFile(wb, "calls_data.xlsx");
};

  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);

  // const fetchCallDetails = async (page, search = "") => {
  //   try {
  //     const response = await axios.get(
  //       `${API_URL}/${id}/userdetails?page=${page}&limit=${itemsPerPage}&search=${search}`
  //     );
  //     setCalls(response.data.calls);
  //     setUser(response.data.user);
  //     setCategorizedCalls(response.data.categorizedCalls);
  //     setTotalPages(response.data.pagination.totalPages);
  //   } catch (error) {
  //     console.error("Error fetching call details:", error);
  //   }
  // };

  const fetchLeadDetails = async ()=>{
    try{
      const response = await axios.get(`${API_URL}/getLead/${id}`);
      setLead(response.data);
      
    }catch(error){
      console.error("Error fetching lead details: ", error);
    }
  }

  const fetchCallDetails = async()=>{
    try{
      const response = await axios.get(`${API_URL}/callsByLeadId/${id}`);
      const calls = response.data.calls;
      setCalls(response.data.calls);
      const nameMap = {};
      await Promise.all(
        calls.map(async (call) => {
          if (call.emp_id) {
            try {
              const personRes = await axios.get(`${API_URL}/employees/${call.emp_id}`);
              if (personRes.status === 200) {
                nameMap[call.emp_id] = personRes.data.ename;
              }
            } catch (err) {
              nameMap[call.emp_id] = "N/A";
              console.error("Error fetching person name for ID:", call.emp_id, err);
            }
          }
        }));
        setPersonNames(nameMap);
    }catch(error){
      console.error("error fetching calls: ", error);
    }
  }

  useEffect(()=>{
    fetchLeadDetails();
    fetchCallDetails();
  },[]
  );

  // useEffect(() => {
    
  //   const delayDebounceFn = setTimeout(() => {
      
  //     fetchCallDetails(currentPage, search);
  //   }, 500);
  //   return () => clearTimeout(delayDebounceFn);
  // }, [currentPage, search]);

  // Filter calls based on search input

  return (
    <div style={{ padding: "20px" }}>
      <div className="flex justify-between items-center mb-4">
        <h1 className="text-2xl font-bold">Lead Details</h1>
        <button
          onClick={downloadexcel}
          className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-700"
        >
          Download Excel
        </button>
      </div>
      {lead ? (
        <div className="border rounded p-4 mb-6 bg-gray-100">
          <p>
            <strong>Name:</strong> {lead.name}
          </p>
          <p>
            <strong>Email:</strong> {lead.email}
          </p>
          <p>
            <strong>Phone:</strong> {lead.number}
          </p>
          <p>
            <strong>Assigned to :</strong> {lead.person_id}-{lead.owner}
          </p>
          <p>
            <strong>Status:</strong> {lead.status}
          </p>
          <p>
            <strong>Source:</strong> {lead.source}
          </p>
          <p>
            <strong>Priority:</strong> {lead.priority}
          </p>
          <p>
  <strong>Next Meeting:</strong>{" "}
  {new Date(lead.next_meeting).toLocaleString("en-IN", {
    dateStyle: "medium",
    timeStyle: "short",
  })}
</p>
          <p>
            <strong>Loan Type:</strong> {lead.loan_type}
          </p>
          <p>
            <strong>Estimated Budget:</strong> {lead.est_budget}
          </p>
          <p>
            <strong>Refrence:</strong> {lead.refrence}
          </p>
           <p>
            <strong>Remark:</strong> {lead.remark}
          </p> 
           <p>
  <strong>Created At:</strong>{" "}
  {new Date(lead.createdAt).toLocaleString("en-IN", {
    dateStyle: "medium",
    timeStyle: "short",
  })}
</p>
           <p>
            <strong>Address:</strong> {lead.address}
          </p>  
           <p>
            <strong>Description:</strong> {lead.description}
          </p>       
        </div>
      ) : (
        <p>Loading Lead details...</p>
      )}

      <h2 className="text-xl font-bold mb-4">Call Details</h2>
      {calls.length ? (
        <div className="border rounded p-4 mb-6 bg-gray-100">
          <p>
            <strong>Total Calls:</strong> {calls.length}
          </p>
        </div>
      ) : (
        <p>No related calls found</p>
      )}

      {/* <div className="mb-4">
        <input
          type="text"
          placeholder="Search calls..."
          className="border p-2 rounded w-full"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div> */}

      <h3 className="text-lg font-bold mb-2">All Calls</h3>
      <table className="table-auto w-full border-collapse border border-gray-300">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">Called By</th>
            <th className="border border-gray-300 px-4 py-2">Phone</th>
            <th className="border border-gray-300 px-4 py-2">Remark</th>
            {/* <th className="border border-gray-300 px-4 py-2">Call date</th> */}

            <th className="border border-gray-300 px-4 py-2">Date-Time</th>

            {/* <th className="border border-gray-300 px-4 py-2">Status</th>
            <th className="border border-gray-300 px-4 py-2">Project Name</th>
            <th className="border border-gray-300 px-4 py-2">Call Remark</th>
            <th className="border border-gray-300 px-4 py-2">
              Site Visit Remark
            </th>

            <th className="border border-gray-300 px-4 py-2">Site Visit</th> */}
          </tr>
        </thead>
        <tbody>
          {calls.length > 0 ? (
            calls.map((call, index) => (
              <tr key={index} className="hover:bg-gray-50">
                <td className="border border-gray-300 px-4 py-2">
                  {personNames[call.emp_id] || "N/A"}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {call.number}
                </td>

                {/* call duration */}
                {/* <td
                  className={`${
                    call.isverified ? "bg-green-500" : ""
                  } border border-gray-300 px-4 py-2`}
                >
                  {call.isverified ? "Yes" : "No"}
                </td>
                <td
                  className={`${
                    call.isverified ? "bg-green-500" : ""
                  } border border-gray-300 px-4 py-2`}
                >
                  {call.isverified ? "Yes" : "No"}
                </td> */}
                <td className="border border-gray-300 px-4 py-2">
                  {call.remark}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {new Date(call.createdAt).toLocaleString("en-IN", {
    dateStyle: "medium",
    timeStyle: "short",
  })}
                </td>

                {/* <td
                  className={`${
                    call.status === "interested"
                      ? "bg-green-200"
                      : call.status === "future"
                      ? "bg-yellow-200"
                      : ""
                  } border border-gray-300 px-4 py-2`}
                >
                  {call.status}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {call.projectname}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {call.callremark || "--"}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {call.sitevisiteremark || "--"}
                </td>

                <td
                  className={`${
                    call.isverified ? "bg-green-500" : ""
                  } border border-gray-300 px-4 py-2`}
                >
                  {call.isverified ? "Yes" : "No"}
                </td> */}
              </tr>
            ))
          ) : (
            <tr>
              <td
                colSpan="4"
                className="text-center border border-gray-300 px-4 py-2"
              >
                No calls found
              </td>
            </tr>
          )}
        </tbody>
      </table>
      {isLoading && (
        <div className="flex justify-center mt-4">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
        </div>
      )}
      <div className="flex justify-center mt-4 gap-2">
        <button
          onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
          disabled={currentPage === 1}
          className="px-4 py-2 bg-blue-500 text-white rounded disabled:bg-gray-300"
        >
          Previous
        </button>
        <span className="px-4 py-2">
          Page {currentPage} of {totalPages}
        </span>
        <button
          onClick={() => setCurrentPage((prev) => prev + 1)}
          disabled={currentPage === totalPages}
          className="px-4 py-2 bg-blue-500 text-white rounded disabled:bg-gray-300"
        >
          Next
        </button>
      </div>
    </div>
  );
};

export default UserDetailScreen;
