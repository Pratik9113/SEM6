import React, {useState, useEffect } from 'react';
import pratik from '../../pratik.png'
import './Home.css';
import Typewriter from 'typewriter-effect';
const Home = () => {
  const [ showTypewriter, setShowTypewriter] = useState(true);
  useEffect(()=>{
    const timer = setTimeout(()=>{
      setShowTypewriter(false);
    },9000);
    return () => clearTimeout(timer);
  },[]);
  return (
    <>
    <div className="home-section">
      <div className='container-fluid home-container id = "Home"'>
        <div className=' home-content'>
        <h1 className='home-text'>Each project is crafted with unique technologies</h1>
            <h2>
            <Typewriter
                  options={{
                    strings: ['Full-Stack Web Development with MERN Stack!', 'C++ Programming Excellence !','Machine Learning Enthusiast !'],
                    autoStart: true,
                    loop: true,
                  }}
            />
            </h2>
        </div>
        </div>
        <div className='about' id = "About">
          <div className="container">
            <div className="row profile">
              <div className="col-sm-4">
                <div className='about-profile'>
                <img src={pratik} alt='profile pic' />
                </div>
              </div>
              <div className="about-section col-sm-8">
              <div className='about-section-main'>
                    <h1 className='text'>
                      {showTypewriter && (
                    <Typewriter className='about-content-text'
                        options={{   
                          strings: ['About Me - PRATIK PATIL'],
                          autoStart: true,
                          loop:false,
                          
                        }}
                  />
                      )}
                      {!showTypewriter && (
                        <div className='about-content'>
                          <p>About Me - Pratik Patil</p>
                        </div>
                      )}
                    </h1>
                    <div className='about-text'>
                        <p className='about-text-main'>
                        Hello, My name is Pratik Patil. I am currently pursuing a Bachelor of Engineering in Information Technology at V.E.S.I.T, Mumbai, with a CGPA of 8.6. 

                        </p>
                    </div>
                  </div>
                  <div className='profiles' >
                      <div className='github-logo'>
                        <a href ="https://github.com/Pratik9113"><img src = "data:image/png;base64,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" alt = "github-logo"/></a>
                      </div>
                      <div className='leetcode-logo'>
                        <a href='https://leetcode.com/pratik9113_/'><img src = "data:image/png;base64,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" alt = "leetcode-logo "/></a>
                      </div>
                      <div className='linkedin-logo'>
                        <a href ="https://www.linkedin.com/in/pratik-patil-b5681424b/"><img src = "data:image/png;base64,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" alt = "linkedin-logo"/></a>
                      </div>
                    </div>
              </div>
            </div>
          </div>
        </div>
        </div>
    </>
  )
}

export default Home