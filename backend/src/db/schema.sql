-- Create users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255),
  firebase_uid VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  review_count INT DEFAULT 0,
  reputation_score FLOAT DEFAULT 5.0,
  is_admin BOOLEAN DEFAULT false
);

-- Create restaurants table
CREATE TABLE restaurants (
  id SERIAL PRIMARY KEY,
  google_place_id VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  city VARCHAR(100),
  country VARCHAR(100),
  lat DECIMAL(10, 8),
  lng DECIMAL(11, 8),
  overall_bathroom_score FLOAT DEFAULT 0,
  review_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create reviews table
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  restaurant_id INT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  photo_url VARCHAR(500),
  -- Hygiene criteria (1-5)
  floor_condition INT CHECK (floor_condition >= 1 AND floor_condition <= 5),
  toilet_condition INT CHECK (toilet_condition >= 1 AND toilet_condition <= 5),
  sink_cleanliness INT CHECK (sink_cleanliness >= 1 AND sink_cleanliness <= 5),
  soap_availability INT CHECK (soap_availability >= 1 AND soap_availability <= 5),
  paper_availability INT CHECK (paper_availability >= 1 AND paper_availability <= 5),
  smell INT CHECK (smell >= 1 AND smell <= 5),
  -- Experience criteria (1-5)
  lighting INT CHECK (lighting >= 1 AND lighting <= 5),
  ventilation INT CHECK (ventilation >= 1 AND ventilation <= 5),
  aesthetic INT CHECK (aesthetic >= 1 AND aesthetic <= 5),
  music INT CHECK (music >= 1 AND music <= 5),
  atmosphere INT CHECK (atmosphere >= 1 AND atmosphere <= 5),
  -- Calculated scores
  hygiene_score FLOAT,
  experience_score FLOAT,
  overall_score FLOAT,
  text_notes TEXT,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'flagged')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, restaurant_id, created_at::date)
);

-- Create flags table
CREATE TABLE flags (
  id SERIAL PRIMARY KEY,
  review_id INT NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reason VARCHAR(500) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX idx_restaurants_google_place_id ON restaurants(google_place_id);
CREATE INDEX idx_reviews_restaurant_id ON reviews(restaurant_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_reviews_status ON reviews(status);
CREATE INDEX idx_reviews_created_at ON reviews(created_at);
CREATE INDEX idx_flags_review_id ON flags(review_id);
CREATE INDEX idx_users_firebase_uid ON users(firebase_uid);