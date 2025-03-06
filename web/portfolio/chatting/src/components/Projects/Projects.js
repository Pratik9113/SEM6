import React from 'react';
import './Projects.css';
import speechify from "../../assets/speechify.png";
import taskManagement from "../../assets/taskManagement.png"
import faceRecognition from "../../assets/faceRecognition.png"
import portfolio from "../../assets/Portfolio.png"
import bail from "../../assets/bail.png"
import vaccine from "../../assets/vaccine.png"
const Projects = () => {
  const projectList = [
    {
      title: 'Bail Bridges ',
      description: `Created a system to automate the bail process, enhancing efficiency, reducing manual tasks, and ensuring secure access to
user data. My Contribution is to develop facial recognition with spoofing detection and tracking; created a police dashboard
for real-time user monitoring and management of users`,
      image: bail,
      videoLink: "https://github.com/Pratik9113/SIH2024.git",
      liveLink: "https://github.com/Pratik9113/SIH2024.git"
    },
    {
      title: 'Vaccination Center',
      description: `Developed backend for a vaccination center management system, implementing JWT authentication for secure access,
automated vaccine notifications for parents
 Rate limiting to prevent server overload, while handling all CRUD operations for managing appointments and vaccination
data`,
      image: vaccine,
       videoLink: "https://github.com/Pratik9113/vaccination_track.git",
      liveLink: "https://github.com/Pratik9113/vaccination_track.git"
    },
    {
      title: 'Speechify',
      description: 'Implemented high-accuracy speech-to-text, multi-language text translation, audio-to-text, and text-to-speech capabilities',
      image: speechify,
      videoLink: "https://github.com/Pratik9113/Future-ready-talent-Project-speechify.git",
      liveLink: "https://ashy-pond-07114da10.5.azurestaticapps.net/"
    },
    {
      title: 'Task Management',
      description: 'task management system with comprehensive CRUD features, empowering users to streamline worklow processes with email facilities',
      image: taskManagement,
      videoLink: "https://github.com/Pratik9113/Task-Management-Web-Application-with-Email-Reminders.git",
      liveLink: "https://task-management-web-application-with-email-reminders-lm64.vercel.app/"
    },
    {
      title: 'Face recognition',
      description: 'automatic attendance tracking through facial recognition, ensuring face detection accuracy achieving an impressive accuracy range of 89% to 95%.',
      image: faceRecognition,
      videoLink: "https://github.com/Pratik9113/Pythonic-pioneers.git",
      liveLink: "https://github.com/Pratik9113/Pythonic-pioneers.git"
    },
    {
      title: 'PortFolio',
      description: 'Implemented an intuitive and visually appealing user interface to enhance user experience and engagement',
      image: portfolio,
      videoLink: "https://github.com/Pratik9113/portfolio.git",
      liveLink: "https://portfolio-pratik-chi.vercel.app/"
    },
  ];

  return (
    <div className="div">
    <div className='projects-container'>
      {projectList.map((project, index) => (
        <div key={index} className="cards">
          <img src={project.image} className="cards-img-top" alt="project logo" />
          <div className="cards-body">
            <h5 className="cards-title">{project.title}</h5>
            <p className="cards-text">{project.description}</p>
            <div className="project-links">
              <a href={project.liveLink} className="btn btn-primary">Live</a>
              <a href={project.videoLink} className="btn btn-danger">GitHub</a>
            </div>
          </div>
        </div>
      ))}
    </div>
    </div>
  );
}

export default Projects;