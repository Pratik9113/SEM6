import React from 'react'
import { MdSchool } from 'react-icons/md/index.js';
import './Education.css'

const Education = () => {
    return (
      <>
        <div className="education" id="Education">
          <div className="spaces"></div>
          <h1 className="mt-3 mb-1 text-center">Education</h1>
          <hr />
          <div className="vertical-timeline">
            <div className="vertical-timeline-element--education">
              <div className="vertical-timeline-element-content">
                <div className="vertical-timeline-element-date">Nov 2023</div>
                <div className="icon-wrapper" style={{ background: 'rgb(233, 30, 99)', color: '#fff' }}>
                  <MdSchool />
                </div>
                <h3 className="vertical-timeline-element-title">Class 10</h3>
                <h4 className="vertical-timeline-element-subtitle">Merit High School </h4>
                <p>I achieved 97% in Class 10 </p>
              </div>
            </div>

            <div className="vertical-timeline-element--work">
              <div className="vertical-timeline-element-content">
                <div className="vertical-timeline-element-date">2021 - 2022</div>
                <div className="icon-wrapper" style={{ background: 'rgb(33, 150, 243)', color: '#fff' }}>
                  <MdSchool />
                </div>
                <h3 className="vertical-timeline-element-title">Class 12</h3>
                <h4 className="vertical-timeline-element-subtitle">Merit High School</h4>
                <p>As a PCM student, I achieved a percentage of 89.4 in Class 12. I successfully cracked JEE Advanced and secured a rank of 24,000.</p>
              </div>
            </div>

            <div className="vertical-timeline-element--education">
              <div className="vertical-timeline-element-content">
                <div className="vertical-timeline-element-date">Nov 2023</div>
                <div className="icon-wrapper" style={{ background: 'rgb(233, 30, 99)', color: '#fff' }}>
                  <MdSchool />
                </div>
                <h3 className="vertical-timeline-element-title">V.E.S.I.T (Chembur)</h3>
                <h4 className="vertical-timeline-element-subtitle">University of Mumbai.</h4>
                <p>I am a third-year Information Technology student at V.E.S.I.T, Mumbai, currently pursuing my Bachelor of Engineering degree</p>
              </div>
            </div>
          </div>
        </div>
        <div className='content-space'></div>
      </>
    );
};

export default Education;