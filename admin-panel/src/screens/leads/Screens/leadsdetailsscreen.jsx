import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import axios from "axios";
import API_URL from "../../../config";
import * as XLSX from "xlsx";

const UserDetailScreen = () => {
  const { id } = useParams();
  const [user, setUser] = useState(null);
  const [calls, setCalls] = useState([]);
  const [categorizedCalls, setCategorizedCalls] = useState({});
  const [search, setSearch] = useState(""); // For search functionality
  const [searchTerm, setSearchTerm] = useState("");
  const itemsPerPage = 50;
  const [isLoading, setIsLoading] = useState(false);

  const downloadexcel = () => {
    // Convert calls data to sheet
    const filteredCalls = calls.map(
      ({ createdAt, updatedAt, id, assignedto, calldate, ...rest }) => rest
    );
    const ws = XLSX.utils.json_to_sheet(filteredCalls);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Calls");

    // Trigger Excel download
    XLSX.writeFile(wb, "calls_data.xlsx");
  };
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);

  const fetchCallDetails = async (page, search = "") => {
    try {
      const response = await axios.get(
        `${API_URL}/${id}/userdetails?page=${page}&limit=${itemsPerPage}&search=${search}`
      );
      setCalls(response.data.calls);
      setUser(response.data.user);
      setCategorizedCalls(response.data.categorizedCalls);
      setTotalPages(response.data.pagination.totalPages);
    } catch (error) {
      console.error("Error fetching call details:", error);
    }
  };

  useEffect(() => {
    const delayDebounceFn = setTimeout(() => {
      fetchCallDetails(currentPage, search);
    }, 500);
    return () => clearTimeout(delayDebounceFn);
  }, [currentPage, search]);

  // Filter calls based on search input

  return (
    <div style={{ padding: "20px" }}>
      <div className="flex justify-between items-center mb-4">
        <h1 className="text-2xl font-bold">User Details</h1>
        <button
          onClick={downloadexcel}
          className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-700"
        >
          Download Excel
        </button>
      </div>
      {user ? (
        <div className="border rounded p-4 mb-6 bg-gray-100">
          <p>
            <strong>Name:</strong> {user.name}
          </p>
          <p>
            <strong>Email:</strong> {user.email}
          </p>
          <p>
            <strong>Phone:</strong> {user.phone}
          </p>
          <p>
            <strong>Role:</strong> {user.role}
          </p>
          <p>
            <strong>Points:</strong> {user.points}
          </p>
        </div>
      ) : (
        <p>Loading user details...</p>
      )}

      <h2 className="text-xl font-bold mb-4">Call Details</h2>
      {categorizedCalls.total ? (
        <div className="border rounded p-4 mb-6 bg-gray-100">
          <p>
            <strong>Total Calls:</strong> {categorizedCalls.total}
          </p>
          <p>
            <strong>Interested:</strong> {categorizedCalls.interested}
          </p>
          <p>
            <strong>Not Interested:</strong> {categorizedCalls.notInterested}
          </p>
          <p>
            <strong>Future:</strong> {categorizedCalls.future}
          </p>
          <p>
            <strong>Remaining Calls:</strong> {categorizedCalls.uncompleted}
          </p>
          <p>
            {/* <strong>Uncompleted:</strong> {categorizedCalls.uncompleted} */}
          </p>
          <p>
            <strong>Wrong numbers:</strong> {categorizedCalls.wrongnumber}
          </p>
          <p>
            <strong>Not connected:</strong> {categorizedCalls.noconnect}
          </p>
        </div>
      ) : (
        <p>Loading call details...</p>
      )}

      <div className="mb-4">
        <input
          type="text"
          placeholder="Search calls..."
          className="border p-2 rounded w-full"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div>

      <h3 className="text-lg font-bold mb-2">All Calls</h3>
      <table className="table-auto w-full border-collapse border border-gray-300">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">Name</th>
            <th className="border border-gray-300 px-4 py-2">Phone</th>
            {/* <th className="border border-gray-300 px-4 py-2">Call date</th> */}

            <th className="border border-gray-300 px-4 py-2">Call Duration</th>

            <th className="border border-gray-300 px-4 py-2">Status</th>
            <th className="border border-gray-300 px-4 py-2">Project Name</th>
            <th className="border border-gray-300 px-4 py-2">Call Remark</th>
            <th className="border border-gray-300 px-4 py-2">
              Site Visit Remark
            </th>

            <th className="border border-gray-300 px-4 py-2">Site Visit</th>
          </tr>
        </thead>
        <tbody>
          {calls.length > 0 ? (
            calls.map((call, index) => (
              <tr key={index} className="hover:bg-gray-50">
                <td className="border border-gray-300 px-4 py-2">
                  {call.name || "N/A"}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {call.phone}
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
                  {(() => {
                    const durationInSeconds = call.callduration;
                    if (durationInSeconds === null) {
                      return "";
                    } else if (durationInSeconds < 60) {
                      return `${durationInSeconds} seconds`;
                    } else if (durationInSeconds < 3600) {
                      const minutes = Math.floor(durationInSeconds / 60);
                      const seconds = durationInSeconds % 60;
                      return `${minutes} minutes ${seconds} seconds`;
                    } else {
                      const hours = Math.floor(durationInSeconds / 3600);
                      const minutes = Math.floor(
                        (durationInSeconds % 3600) / 60
                      );
                      return `${hours} hours ${minutes} minutes`;
                    }
                  })()}
                </td>

                <td
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
                </td>
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
