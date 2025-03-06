import React from 'react'
import "./Achievement.css"
import leet50 from "../../assets/leetcode2024.png"
import leet100 from "../../assets/leetcode100.png"

const Achievement = () => {
  return (
    <div>
        <div class="row">
          <div class="col-lg-4 col-md-6 d-flex align-items-stretch mt-4">
            <div class="icon-box w-50">
              <div class="mb-4">
                <img src= {leet50} alt=""/>
              </div>
              <h4>50-Days Leetcode</h4>
              <p class="fs-6"></p>
            </div>
          </div>

          <div class="col-lg-4 col-md-6 d-flex align-items-stretch mt-4">
            <div class="icon-box w-100">
              <div class="mb-4">
                <img src={leet100} alt=""/>
              </div>
              <h4>100-Days Leetcode</h4>
              <p class="fs-6"></p>
            </div>
          </div>

          <div class="col-lg-4 col-md-6 d-flex align-items-stretch mt-4">
            <div class="icon-box w-50">
              <div class="mb-4">
                <img src= {leet50} alt=""/>
              </div>
              <h4>50-Days Leetcode</h4>
              <p class="fs-6"></p>
            </div>
          </div>

          <div class="col-lg-4 col-md-6 d-flex align-items-stretch mt-4">
            <div class="icon-box w-50">
              <div class="mb-4">
                <img src= {leet50} alt=""/>
              </div>
              <h4>50-Days Leetcode</h4>
              <p class="fs-6"></p>
            </div>
          </div>
        </div>
    </div>
  )
}

export default Achievement
