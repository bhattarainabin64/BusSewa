import { Route, Routes } from "react-router-dom";
import AdminDashboard from "./admin/admindashboard";
import Read from "./admin/read";
import Promo from "./admin/Promo";

const Mid = () => {
  return (
    <Routes>
      {/* <Route path="/login" element={<Login/>}></Route> */}
      <Route path="/" element={<AdminDashboard />}></Route>
      <Route path="/read" element={<Read />}></Route>
        <Route path={'/promo'} element={<Promo/>}></Route>
    </Routes>
  );
};
export default Mid;
