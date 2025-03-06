import React from 'react'
import "./Experience.css"
const Experience = () => {
  return (
        <div className="Experience">
            <div className="experience-list-display">
              <div className="content-space"></div>
            <div className="resume-item">
              <h4>Software Developer Intern</h4>
              <h5>Jun 2024 - Present</h5>
              <p><em>SUD Life Insurance</em></p>
              <ul className="experience-list">
                <li>Actively participated in web development projects and team meetings during the internship program.</li>
              </ul> 
            </div>
            <div className="content-space"></div>
            <div className="resume-item">
              <h4>Virtual Intern </h4>
              <h5>May 2024 - Jun 2024</h5>
              <p><em>Microsoft Future Ready Talent Virtual Internship</em></p>
              <ul className="experience-list">
                <li>Acquired practical experience with Azure tools, including Speech Services and Azure Static Websites.</li>
                <li>Demonstrated proficiency in Git & GitHub for version control and collaboration.</li>
                <li>Engaged in hands-on projects simulating real-world scenarios, enhancing skills and technical expertise.</li>
              </ul>
            </div>
            </div>
        </div>
  )
}

export default Experience
