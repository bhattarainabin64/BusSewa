import React, {useEffect, useState} from 'react'
import {addDoc, collection, getDocs, updateDoc} from "firebase/firestore";
import {db} from "../../firebase";

const Promo = () => {
    const [promoCode, setPromoCode] = useState('');
    const [promoDescription, setPromoDescription] = useState('');
    // validity
    const [promoStartDate, setPromoStartDate] = useState('');
    const [promoEndDate, setPromoEndDate] = useState('');
    const [data, setData] = useState([]);
    
    const handleSubmit = async (e) => {
        e.preventDefault();
        console.log(promoCode, promoDescription, promoStartDate, promoEndDate);
        try {
            const promoRef = collection(db, "promo");
            // create a new document
            const docRef = await addDoc(promoRef, {
                promoCode: promoCode,
                promoDescription: promoDescription,
                promoStartDate: promoStartDate,
                promoEndDate: promoEndDate
            });

            // add to data locally
            setData([...data, {
                promoCode: promoCode,
                promoDescription: promoDescription,
                promoStartDate: promoStartDate,
                promoEndDate: promoEndDate
            }])


        } catch (e) {
            console.log(e);
        }
    }
    const fetchData = async () => {
        const querySnapshot = await getDocs(collection(db, "promo"));
        querySnapshot.forEach((doc) => {
            console.log(doc.id, " => ", doc.data());
            setData((prev) => [...prev, doc.data()]);
        });
    };

    useEffect(() => {
        fetchData();
    }, []);


    return <>
      <div className="container ">
          <div className="d-flex mt-2 justify-content-between">
              <h2>Roadway promo center</h2>
              <button type="button" className="btn btn-sm btn-success" data-mdb-toggle="modal"
                      data-mdb-target="#exampleModal">
                  Add promo code
              </button>
          </div>
          <div className="modal fade" id="exampleModal" tabIndex="-1" aria-labelledby="exampleModalLabel"
               aria-hidden="true">
              <div className="modal-dialog">
                  <div className="modal-content">
                      <div className="modal-header">
                          <h5 className="modal-title" id="exampleModalLabel">Add Promo Code</h5>
                          <button type="button" className="btn-close btn-success" data-mdb-dismiss="modal"
                                  aria-label="Close"></button>
                      </div>
                      <div className="modal-body">
                          <React.Fragment>
                              <form  onSubmit={handleSubmit}>
                                  <div className="form-group">
                                      <label htmlFor="promoCode">Promo Code</label>
                                      <input type="text" className="form-control" id="promoCode"
                                        onChange={(e) => setPromoCode(e.target.value)}
                                             value={promoCode}
                                          name="promoCode" placeholder="Enter promo code"/>
                                  </div>
                                  <div className="form-group">
                                      <label htmlFor="description">Description</label>
                                      <textarea className="form-control" id="description" name="description"
                                                onChange={(e) => setPromoDescription(e.target.value)}
                                                value={promoDescription}
                                                rows="3"></textarea>
                                  </div>
                                  <div className="form-group">
                                      <label htmlFor="startDate">Start Date</label>
                                      <input type="date" className="form-control" id="startDate"
                                                onChange={(e) => setPromoStartDate(e.target.value)}
                                                value={promoStartDate}
                                             name="startDate"/>
                                  </div>
                                  <div className="form-group">
                                      <label htmlFor="endDate">End Date</label>
                                      <input type="date" className="form-control" id="endDate" name="endDate"
                                                onChange={(e) => setPromoEndDate(e.target.value)}
                                                value={promoEndDate}
                                      />
                                  </div>

                              </form>
                          </React.Fragment>
                      </div>
                      <div className="modal-footer">
                          <button type="button" className="btn btn-secondary" data-mdb-dismiss="modal">Close
                          </button>
                          <button type="button" onClick={handleSubmit} className="btn btn-primary">Save changes</button>
                      </div>
                  </div>
              </div>
          </div>

          <table className="table">
              <thead className="table-light"></thead>

              <tbody>
              <tr className={'fw-bold'}>
                  <td>PROMO CODE</td>
                  <td>DESCRIPTION</td>
                  <td>VALIDITY</td>
                  <td>STATUS</td>
                    <td>ACTION</td>
              </tr>
                {data.map((item, index) => {
                    return <tr key={index}>
                        <td>{item.promoCode}</td>
                        <td>{item.promoDescription}</td>
                        <td>{item.promoStartDate} - {item.promoEndDate}</td>
                        <td>
                            <span className="badge bg-success">Active</span>

                        </td>
                        <td>
                            <button type="button" className="btn btn-sm btn-success" data-mdb-toggle="modal"
                                    data-mdb-target="#exampleModal">
                                Edit
                            </button>
                            <button type="button" className="btn btn-sm btn-danger" data-mdb-toggle="modal"
                                    data-mdb-target="#exampleModal">
                                Delete
                            </button>
                        </td>
                    </tr>

                })}

              </tbody>
          </table>
      </div>
  </>
}

export default Promo