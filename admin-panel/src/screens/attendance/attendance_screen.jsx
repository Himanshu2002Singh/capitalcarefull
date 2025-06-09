import React, { useEffect, useState } from "react";
import axios from "axios";
import API_URL from "../../config";

const AttendanceScreen = () => {
  const [attendanceData, setAttendanceData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [employees, setEmployees] = useState([]);
  const [selectedMonth, setSelectedMonth] = useState(() => {
    const currentMonth = new Date().toISOString().slice(0, 7); // YYYY-MM
    return currentMonth;
  });
  const [currentPage, setCurrentPage] = useState(1);
const recordsPerPage = 20; 
const indexOfLastRecord = currentPage * recordsPerPage;
const indexOfFirstRecord = indexOfLastRecord - recordsPerPage;


  // Fetch attendance data
  useEffect(() => {
    const fetchAttendance = async () => {
      try {
        setLoading(true);
        const response = await axios.get(
          `${API_URL}/monthlyattendance/${selectedMonth}`
        );
        setAttendanceData(response.data.attendance);
        
      } catch (error) {
        console.error("Error fetching attendance data", error);
      } finally {
        setLoading(false);
      }
    };

    fetchAttendance();
  }, [selectedMonth]);

  // Fetch employee list
  useEffect(() => {
    const fetchEmployees = async () => {
      try {
        const res = await axios.get(`${API_URL}/employees`);
        setEmployees(res.data.employees);
      } catch (error) {
        console.error("Error fetching employees:", error);
      }
    };

    fetchEmployees();
  }, []);

  // Helpers
  const getDaysInMonth = (monthStr) => {
    const [year, month] = monthStr.split("-").map(Number);
    return new Date(year, month, 0).getDate();
  };

  // Group attendance by userId and date
  const groupedAttendance = {};
  attendanceData.forEach((record) => {
    const { userId, date, isLate } = record;
    const day = new Date(date).getDate();
    if (!groupedAttendance[userId]) groupedAttendance[userId] = {};
    groupedAttendance[userId][day] = isLate ? "late" : "full";
  });

  // Final processed data
  const totalDays = getDaysInMonth(selectedMonth);
  const processedData = employees.map((emp) => {
    const days = [];
    let full = 0;
    let late = 0;

    for (let i = 1; i <= totalDays; i++) {
      const status = groupedAttendance[emp.emp_id]?.[i];
      if (status === "full") {
        days.push({ symbol: "✅", className: "bg-green-100" });
        full++;
      } else if (status === "late") {
        days.push({ symbol: "🟨", className: "bg-yellow-100" });
        late++;
      } else {
        days.push({ symbol: "", className: "" });
      }
    }

    return {
      userId: emp.emp_id,
      name: emp.ename,
      total: full + late,
      full,
      late,
      days,
    };
  });

  const currentRecords = processedData.slice(indexOfFirstRecord, indexOfLastRecord);

const totalPages = Math.ceil(processedData.length / recordsPerPage);

  const renderPageNumbers = () => {
  const maxVisible = 5;
  let startPage = Math.max(currentPage - Math.floor(maxVisible / 2), 1);
  let endPage = startPage + maxVisible - 1;

  if (endPage > totalPages) {
    endPage = totalPages;
    startPage = Math.max(endPage - maxVisible + 1, 1);
  }

  const pages = [];

  if (currentPage > 1) {
    pages.push(
      <button
        key="prev"
        onClick={() => setCurrentPage(currentPage - 1)}
        className="px-3 py-1 border bg-white"
      >
        Prev
      </button>
    );
  }

  for (let i = startPage; i <= endPage; i++) {
    pages.push(
      <button
        key={i}
        onClick={() => setCurrentPage(i)}
        className={`px-3 py-1 border ${
          i === currentPage ? "bg-blue-500 text-white" : "bg-white"
        }`}
      >
        {i}
      </button>
    );
  }

  if (currentPage < totalPages) {
    pages.push(
      <button
        key="next"
        onClick={() => setCurrentPage(currentPage + 1)}
        className="px-3 py-1 border bg-white"
      >
        Next
      </button>
    );
  }

  return pages;
};


  return (
    <div className="p-4 overflow-auto">
      <h2 className="text-2xl font-semibold mb-4">Attendance</h2>

      <label className="mb-4 block">
        <span className="font-medium">Select Month:</span>
        <input
          type="month"
          value={selectedMonth}
          onChange={(e) => setSelectedMonth(e.target.value)}
          className="border rounded px-2 py-1 ml-2"
        />
      </label>

      {loading ? (
        <p className="mt-4">Loading attendance...</p>
      ) : (
        <div className="overflow-x-auto">
          <table className="min-w-full border text-sm text-center border-collapse">
            <thead className="bg-gray-100 sticky top-0 z-10">
              <tr>
                <th className="border px-2 py-1">Emp ID</th>
                <th className="border px-2 py-1">Name</th>
                <th className="border px-2 py-1">Total</th>
                <th className="border px-2 py-1">Full</th>
                <th className="border px-2 py-1">Late</th>
                {[...Array(totalDays)].map((_, i) => (
                  <th key={i} className="border px-1 py-1 text-xs">{i + 1}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {currentRecords.map((emp, idx) => (
                <tr key={idx} className="hover:bg-gray-50">
                  <td className="border px-2 py-1 font-medium">{emp.userId}</td>
                  <td className="border px-2 py-1">{emp.name}</td>
                  <td className="border px-2 py-1">{emp.total}</td>
                  <td className="border px-2 py-1">{emp.full}</td>
                  <td className="border px-2 py-1">{emp.late}</td>
                  {emp.days.map((day, i) => (
                    <td
                      key={i}
                      className={`border px-1 py-1 ${day.className}`}
                    >
                      {day.symbol}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      <div className="flex gap-2 justify-center mt-4 flex-wrap">
  {renderPageNumbers()}
</div>
    </div>
  );
};

export default AttendanceScreen;
