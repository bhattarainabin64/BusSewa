import React, { useState, useEffect } from "react";
import AdminHeader from "./adminheader";

import { db } from "../../firebase";
import {
  collection,
  addDoc,
  Timestamp,
  doc,
  getDocs,
  updateDoc,
} from "firebase/firestore";


const AdminDashboard = () => {
  const [data, setData] = useState([]);
  const [verify, setVerify] = useState(false);
  const fetchData = async () => {
    const querySnapshot = await getDocs(collection(db, "user"));
    querySnapshot.forEach((doc) => {
      setData((prev) => [...prev, doc.data()]);
    });
  };

  const getUser = (id) => {
    console.log(id);

    const docRef = doc(db, "user", id);
    console.log(docRef);
    updateDoc(docRef, {
      "user_information.isRider": true,
    });
  };
  // update doc data function
  //

  useEffect(() => {
    fetchData();
  }, []);

  return (
      <>
        <AdminHeader />
        <div class="container py-5">
          <section class="mb-5">
            <div class="row gx-xl-5">
              <div class="col-xl-3 col-md-6 mb-4 mb-xl-0">
                <a
                    class="
                  d-flex
                  align-items-center
                  p-4
                  bg-glass
                  shadow-3-strong
                  rounded-6
                  text-reset
                  ripple
                  "
                    href="#"
                    data-ripple-color="hsl(0, 0%, 75%)"
                >
                  <div class="rounded-4 fs-1">
                    <i class="fa fa-user"></i>
                  </div>

                  <div class="ms-4">
                    <p class="text-muted mb-2">Users</p>
                    <p class="mb-0">
                      <span class="h5 me-2">{data.length}</span>
                      <small class="text-success text-sm">
                        <i class="fas fa-arrow-up fa-sm me-1"></i>13.48%
                      </small>
                    </p>
                  </div>
                </a>
              </div>
              <div class="col-xl-3 col-md-6 mb-4 mb-xl-0">
                <a
                    class="
                  d-flex
                  align-items-center
                  p-4
                  bg-glass
                  shadow
                  rounded-6
                  text-reset
                  ripple
                  "
                    href="/promo"
                    data-ripple-color="hsl(0, 0%, 75%)"
                >
                  <div class="fs-1 rounded-4">
                    <i class="fa fa-eye"></i>
                  </div>

                  {/* <div class="ms-4">
                  <p class="text-muted mb-2">Product views</p>
                  <p class="mb-0">
                    <span class="h5 me-2">12</span>
                    <small class="text-success text-sm">
                      <i class="fas fa-arrow-up fa-sm me-1"></i>23.58%
                    </small>
                  </p>
                </div> */}
                </a>
              </div>

              <div class="col-xl-3 col-md-6 mb-4 mb-xl-0">
                <a
                    class="
                  d-flex
                  align-items-center
                  p-4
                  bg-glass
                  shadow
                  rounded-6
                  text-reset
                  ripple
                  "
                    href="#"
                    data-ripple-color="hsl(0, 0%, 75%)"
                >
                  <div class="fs-1 rounded-4">
                    <i class="fa fa-clock"></i>
                  </div>

                  {/* <div class="ms-4">
                  <p class="text-muted mb-2">Total Active Products</p>
                  <p class="mb-0">
                    <span class="h5 me-2">14</span>
                    <small class="text-danger text-sm">
                      <i class="fas fa-arrow-down fa-sm me-1"></i>23,58%
                    </small>
                  </p>
                </div> */}
                </a>
              </div>

              <div class="col-xl-3 col-md-6 mb-4 mb-xl-0">
                <a
                    class="
                  d-flex
                  align-items-center
                  p-4
                  bg-glass
                  shadow
                  rounded-6
                  text-reset
                  ripple
                  "
                    href="#"
                    data-ripple-color="hsl(0, 0%, 75%)"
                >
                  <div class="fs-1 rounded-4">
                    <i class="fa fa-heart-rate"></i>
                  </div>

                  {/* <div class="ms-4">
                  <p class="text-muted mb-2">Total Sold Products</p>
                  <p class="mb-0">
                    <span class="h5 me-2">12</span>
                    <small class="text-success text-sm">
                      <i class="fas fa-arrow-down fa-sm me-1"></i>23,58%
                    </small>
                  </p>
                </div> */}
                </a>
              </div>
            </div>
          </section>

          <section class="mb-5">
            <div class="table-responsive bg-glass shadow rounded-6">
              <table
                  class="
                    table table-borderless table-hover
                    align-middle
                    mb-0

                    "
              >
                <thead class="">
                <tr>
                  <th>Name</th>
                  <th>Customer type</th>
                  <th>Account</th>
                  <th>Join date</th>
                  <th>Status</th>
                </tr>
                </thead>
                {data.map((item, key) => (
                    <tbody class="" key={key}>
                    <tr class="text-white">
                      <td>
                        <div class="d-flex align-items-center">
                          {/* React img tag */}
                          <img
                              src="https://mdbootstrap.com/img/new/avatars/2.jpg"
                              class="rounded-circle shadow-1-strong me-3"
                              alt="avatar"
                              width="50"
                              height="50"
                          />

                          <div class="ms-3">
                            <p class="fw-bold mb-1 text-black">
                              {item?.user_information?.firstName}
                              {item?.user_information?.lastName}
                            </p>
                            <p class="text-muted mb-0">
                              {item?.user_information?.email}
                            </p>
                          </div>
                        </div>
                      </td>
                      <td>
                        <p class="fw-bold mb-1 text-black">SPARK</p>
                        <p class="text-muted mb-0">City: Kathmandu</p>
                      </td>
                      <td>
                      <span class="badge badge-danger rounded-pill">
                        <a href="#" class="unlink">
                          Inactive
                        </a>
                      </span>
                      </td>
                      <td class="text-black">24NOV</td>
                      <td>
                        {item?.user_information?.isRider == true ? (
                            <div class="form-check form-switch">
                              <input
                                  class="form-check-input"
                                  type="checkbox"
                                  role="switch"
                                  id="flexSwitchCheckDefault"
                                  checked
                              />
                              <label
                                  class="form-check-label text-black"
                                  for="flexSwitchCheckDefault"
                              >
                                Verified
                              </label>
                            </div>
                        ) : (
                            <div class="form-check form-switch">
                              <input
                                  class="form-check-input"
                                  type="checkbox"
                                  role="switch"
                                  id="flexSwitchCheckDefault"
                                  onClick={() => getUser(item.user_information.uuid)}
                              />
                              <label
                                  class="form-check-label text-black"
                                  for="flexSwitchCheckDefault"
                              >
                                Unverified
                              </label>
                            </div>
                        )}
                      </td>
                    </tr>
                    </tbody>
                ))}
              </table>
            </div>
          </section>
        </div>
      </>
  );
};
export default AdminDashboard;
