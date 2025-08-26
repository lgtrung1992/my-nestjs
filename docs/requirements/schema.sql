-- =====================================================
-- FUND MANAGEMENT SYSTEM DATABASE SCHEMA (PostgreSQL)
-- =====================================================

-- Create database
CREATE DATABASE fundhub;

-- =====================================================
-- ENUM TYPES
-- =====================================================

-- User roles
CREATE TYPE user_role AS ENUM (
    'superAdmin',
    'admin',
    'staff',
    'professor'
);

-- User statuses
CREATE TYPE user_status AS ENUM (
    'active',
    'inactive'
);

-- Fund statuses
CREATE TYPE fund_status AS ENUM (
    'draft',
    'internal_public',
    'internal_deadline_passed',
    'external_application_period',
    'external_deadline_passed',
    'cancelled'
);

-- Application statuses
CREATE TYPE application_status AS ENUM (
    'internal_submitted',
    'internal_reviewer_invited',
    'internal_under_review',
    'internal_ready_for_resubmit',
    'internal_submitted_final',
    'external_submitted',
    'accepted',
    'rejected'
);

-- Review statuses
CREATE TYPE review_status AS ENUM (
    'invited',
    'agreed',
    'declined',
    'review_finished',
    'review_cancelled'
);

-- Fund difficulties
CREATE TYPE fund_difficulty AS ENUM (
    'unknown',
    'normal',
    'hard',
    'very_hard'
);

-- Relevancy levels
CREATE TYPE relevancy_level AS ENUM (
    'relevant',
    'neutral',
    'irrelevant'
);

-- Document types
-- CREATE TYPE document_type AS ENUM (
--     'recruitment_requirement',
--     'format_file',
--     'entry_example_file',
--     'application_document',
--     'review_document',
--     'reference_document',
--     'cv',
--     'proposal',
--     'budget',
--     'other'
-- );

-- Permission request status
CREATE TYPE permission_request_status AS ENUM (
    'pending',
    'approved',
    'rejected',
    'expired'
);

-- Invitation status
CREATE TYPE invitation_status AS ENUM (
    'pending',
    'accepted',
    'declined',
    'expired'
);

-- Fund feedback status
CREATE TYPE fund_feedback_status AS ENUM (
    'will_apply',
    'considering'
);

-- Notification types
CREATE TYPE notification_type AS ENUM (
    'user_registration',
    'fund_created',
    'application_submitted',
    'reviewer_invited',
    'review_submitted',
    'application_status_changed',
    'deadline_reminder',
    'system_alert'
);

-- Message types
CREATE TYPE message_type AS ENUM (
    'text',
    'file',
    'system'
);

-- Chat topic types
CREATE TYPE chat_topic_type AS ENUM (
    'fund_general',      -- General chat for the fund
    'professor_staff',   -- Chat between professor and staff
    'professor_reviewer', -- Chat between professor and reviewer
    'staff_reviewer' -- Chat between staff and reviewer
);

-- organization status
CREATE TYPE organization_status AS ENUM (
    'active',
    'inactive'
);

-- Payment status for organization package purchases
CREATE TYPE payment_status AS ENUM (
    'pending',
    'completed',
    'failed',
    'refunded'
);

-- =====================================================
-- BETTER AUTH CORE TABLES
-- =====================================================

-- Users (Better Auth core table)
CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255),
    username VARCHAR(100) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    is_email_verified BOOLEAN DEFAULT FALSE,
    image VARCHAR(500),
    role user_role DEFAULT 'professor',
    organization_id BIGINT,
    status user_status DEFAULT 'pending',
    last_login_at TIMESTAMP,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    -- Extended user information
    phone VARCHAR(50),
    address TEXT,
    bio TEXT,
    department VARCHAR(255),
    position VARCHAR(255),
    research_field TEXT,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sessions (Better Auth core table)
CREATE TABLE sessions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255) NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    ip_address INET,
    user_agent TEXT,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Accounts (Better Auth core table)
CREATE TABLE accounts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255) NOT NULL,
    account_id VARCHAR(255) NOT NULL,
    provider_id VARCHAR(255) NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    access_token_expires_at TIMESTAMP,
    refresh_token_expires_at TIMESTAMP,
    scope VARCHAR(255),
    id_token TEXT,
    password VARCHAR(255),
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Verifications (Better Auth core table)
CREATE TABLE verifications (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    identifier VARCHAR(255) NOT NULL,
    value VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Two factors
CREATE TABLE two_factors (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    deleted_at TIMESTAMP,
    user_id uuid NOT NULL,
    secret character varying,
    backup_codes character varying,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Passkeys
CREATE TABLE passkeys (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    deleted_at TIMESTAMP,
    name VARCHAR(255),
    user_id uuid NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    public_key VARCHAR(255) NOT NULL,
    credential_id VARCHAR(255) NOT NULL,
    counter integer NOT NULL,
    device_type VARCHAR(255) NOT NULL,
    backed_up BOOLEAN NOT NULL,
    transports VARCHAR(255) NOT NULL,
    aaguid VARCHAR(255) NULL,
);

-- =====================================================
-- FUND MANAGEMENT SYSTEM TABLES
-- =====================================================

-- organizations
CREATE TABLE organizations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_jp VARCHAR(255),
    domain VARCHAR(255) UNIQUE,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    website VARCHAR(500),
    logo_url VARCHAR(500),
    status organization_status DEFAULT 'active',
    -- Professor management fields
    default_professor_limit INTEGER DEFAULT 10,
    current_professor_count INTEGER DEFAULT 0,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Professor packages (for purchasing additional professor slots)
CREATE TABLE professor_packages (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_jp VARCHAR(255),
    description TEXT,
    professor_count INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'JPY',
    duration_months INTEGER DEFAULT 12,
    is_active BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- organization package purchases
CREATE TABLE organization_package_purchases (
    id BIGSERIAL PRIMARY KEY,
    organization_id BIGINT NOT NULL,
    package_id BIGINT NOT NULL,
    purchased_by VARCHAR(255) NOT NULL, -- admin who made the purchase
    quantity INTEGER DEFAULT 1,
    total_price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'JPY',
    payment_status payment_status DEFAULT 'pending',
    payment_method VARCHAR(100),
    transaction_id VARCHAR(255),
    purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activated_at TIMESTAMP,
    expires_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES professor_packages(id),
    FOREIGN KEY (purchased_by) REFERENCES users(id)
);

-- Categories
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_jp VARCHAR(255),
    description TEXT,
    organization_id BIGINT NOT NULL,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE
);

-- Funds
CREATE TABLE funds (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(500) NOT NULL,
    title_jp VARCHAR(500),
    description TEXT,
    category_id BIGINT NOT NULL,
    organization_id BIGINT NOT NULL,
    organization VARCHAR(255) NOT NULL,
    country VARCHAR(100),
    program_type VARCHAR(255),
    difficulty fund_difficulty,
    application_start_date DATE,
    deadline DATE,
    internal_deadline DATE,
    result_announcement DATE,
    research_field TEXT,
    funding_period VARCHAR(255),
    funding_amount VARCHAR(255),
    funding_number INTEGER,
    important_note TEXT,
    remark TEXT,
    graduated_student BOOLEAN DEFAULT FALSE,
    relevancy relevancy_level,
    keywords TEXT,
    recruitment_requirement_url VARCHAR(500),
    homepage_url VARCHAR(500),
    format_file_url VARCHAR(500),
    example_file_url VARCHAR(500),
    is_new BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(255) NOT NULL,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (organization_id) REFERENCES organizations(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Fund tags
CREATE TABLE fund_tags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_jp VARCHAR(100),
    description TEXT,
    color VARCHAR(7) DEFAULT '#007bff',
    is_active BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fund tag relationships
CREATE TABLE fund_tag_relationships (
    id BIGSERIAL PRIMARY KEY,
    fund_id BIGINT NOT NULL,
    tag_id BIGINT NOT NULL,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (fund_id) REFERENCES funds(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES fund_tags(id) ON DELETE CASCADE,
    UNIQUE(fund_id, tag_id)
);

-- Applications
CREATE TABLE applications (
    id BIGSERIAL PRIMARY KEY,
    fund_id BIGINT NOT NULL,
    professor_id VARCHAR(255) NOT NULL,
    status application_status NOT NULL DEFAULT 'internal_submitted',
    submission_count INTEGER DEFAULT 1,
    is_final BOOLEAN DEFAULT FALSE,
    submitted_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (fund_id) REFERENCES funds(id) ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES users(id),
    UNIQUE(fund_id, professor_id)
);

-- Application submission history (tracking each submission)
CREATE TABLE application_submissions (
    id BIGSERIAL PRIMARY KEY,
    application_id BIGINT NOT NULL,
    submission_number INTEGER NOT NULL, -- 1, 2, 3, etc.
    is_final BOOLEAN DEFAULT FALSE,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE,
    UNIQUE(application_id, submission_number)
);

-- Email notification history
CREATE TABLE email_notifications (
    id BIGSERIAL PRIMARY KEY,
    recipient_email VARCHAR(255) NOT NULL,
    recipient_name VARCHAR(255),
    subject VARCHAR(500) NOT NULL,
    content TEXT NOT NULL,
    notification_type VARCHAR(100) NOT NULL, -- 'application_submitted', 'reviewer_notified', etc.
    related_entity_type VARCHAR(100), -- 'application', 'reviewer', 'fund', etc.
    related_entity_id BIGINT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_status VARCHAR(50) DEFAULT 'sent', -- 'sent', 'delivered', 'failed', 'bounced'
    error_message TEXT,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notification recipients tracking (who should be notified for each submission)
CREATE TABLE submission_notification_recipients (
    id BIGSERIAL PRIMARY KEY,
    submission_id BIGINT NOT NULL,
    recipient_type VARCHAR(50) NOT NULL, -- 'reviewer', 'staff', 'professor'
    recipient_id VARCHAR(255), -- user_id if internal user
    recipient_email VARCHAR(255), -- email if external user
    recipient_name VARCHAR(255),
    notification_sent BOOLEAN DEFAULT FALSE,
    email_notification_id BIGINT, -- reference to email_notifications table
    notified_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (submission_id) REFERENCES application_submissions(id) ON DELETE CASCADE,
    FOREIGN KEY (email_notification_id) REFERENCES email_notifications(id) ON DELETE SET NULL
);

-- Fund feedback (moved from applications table)
CREATE TABLE fund_feedback (
    id BIGSERIAL PRIMARY KEY,
    fund_id BIGINT NOT NULL,
    professor_id VARCHAR(255) NOT NULL,
    feedback_status fund_feedback_status NOT NULL,
    notes TEXT,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (fund_id) REFERENCES funds(id) ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(fund_id, professor_id)
);

-- Application documents
CREATE TABLE application_documents (
    id BIGSERIAL PRIMARY KEY,
    application_id BIGINT NOT NULL,
    -- document_type document_type NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,

    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE
);

-- Reviewers
CREATE TABLE reviewers (
    id BIGSERIAL PRIMARY KEY,
    application_id BIGINT NOT NULL,
    user_id uuid NOT NULL,
    status review_status NOT NULL DEFAULT 'invited',
    deadline TIMESTAMP NOT NULL,
    invited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    agreed_at TIMESTAMP,
    declined_at TIMESTAMP,
    submitted_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(application_id, user_id)
);

-- Reviewer invitations (new table for invitation management)
CREATE TABLE reviewer_invitations (
    id BIGSERIAL PRIMARY KEY,
    application_id BIGINT NOT NULL,
    reviewer_id uuid NOT NULL,
    invited_by uuid NOT NULL, -- professor or staff who sent invitation
    invitation_status invitation_status DEFAULT 'pending',
    invitation_deadline TIMESTAMP NOT NULL, -- 1 week from invitation
    review_deadline TIMESTAMP NOT NULL, -- 2 weeks from acceptance
    is_anonymous BOOLEAN DEFAULT FALSE, -- true if invited by staff
    notes TEXT,
    invited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    responded_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (invited_by) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(application_id, reviewer_id)
);

-- Reviewer documents
CREATE TABLE reviewer_documents (
    id BIGSERIAL PRIMARY KEY,
    reviewer_id uuid NOT NULL,
    -- document_type document_type NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,

    FOREIGN KEY (reviewer_id) REFERENCES reviewers(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Chat topics
CREATE TABLE chat_topics (
    id BIGSERIAL PRIMARY KEY,
    fund_id BIGINT NOT NULL,
    topic_type chat_topic_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(255) NOT NULL,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (fund_id) REFERENCES funds(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Chat topic participants (who can see and participate in each topic)
CREATE TABLE chat_topic_participants (
    id BIGSERIAL PRIMARY KEY,
    topic_id BIGINT NOT NULL,
    user_id uuid NOT NULL,
    role VARCHAR(50) NOT NULL, -- 'professor', 'staff', 'reviewer'
    can_send_message BOOLEAN DEFAULT TRUE,
    can_see_messages BOOLEAN DEFAULT TRUE,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (topic_id) REFERENCES chat_topics(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(topic_id, user_id)
);

-- Messages (updated to use chat topics)
CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,
    topic_id BIGINT NOT NULL,
    sender_id VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    message_type message_type DEFAULT 'text',
    is_system_message BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (topic_id) REFERENCES chat_topics(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- Message attachments
CREATE TABLE message_attachments (
    id BIGSERIAL PRIMARY KEY,
    message_id BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE
);

-- Message read status (tracking who has read each message)
CREATE TABLE message_read_status (
    id BIGSERIAL PRIMARY KEY,
    message_id BIGINT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    read_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(message_id, user_id)
);

-- Notifications
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    type notification_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    related_id BIGINT,
    related_type VARCHAR(100),
    is_read BOOLEAN DEFAULT FALSE,
    is_email_sent BOOLEAN DEFAULT FALSE,
    email_sent_at TIMESTAMP,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Notification templates
CREATE TABLE notification_templates (
    id BIGSERIAL PRIMARY KEY,
    type notification_type NOT NULL,
    title_template VARCHAR(500) NOT NULL,
    message_template TEXT NOT NULL,
    email_subject_template VARCHAR(500),
    email_body_template TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User notification preferences
CREATE TABLE user_notification_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    notification_type notification_type NOT NULL,
    in_app_enabled BOOLEAN DEFAULT TRUE,
    email_enabled BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, notification_type)
);

-- Fund favorites
CREATE TABLE fund_favorites (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    fund_id BIGINT NOT NULL,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (fund_id) REFERENCES funds(id) ON DELETE CASCADE,
    UNIQUE(user_id, fund_id)
);

-- Permission requests for documents
CREATE TABLE permission_requests (
    id BIGSERIAL PRIMARY KEY,
    fund_id BIGINT NOT NULL,
    document_owner_email VARCHAR(255) NOT NULL,
    document_owner_name VARCHAR(255),
    document_description TEXT,
    request_reason TEXT,
    status permission_request_status DEFAULT 'pending',
    request_deadline TIMESTAMP NOT NULL, -- 1 month from request
    requested_by VARCHAR(255) NOT NULL, -- staff who requested permission
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    responded_at TIMESTAMP,
    response_notes TEXT,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (fund_id) REFERENCES funds(id) ON DELETE CASCADE,
    FOREIGN KEY (requested_by) REFERENCES users(id)
);

-- Audit logs
CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id uuid,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    deleted_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Better Auth tables indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_organization_id ON users(organization_id);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_last_login_at ON users(last_login_at);
CREATE INDEX idx_users_deleted_at ON users(deleted_at);

CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_token ON sessions(token);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);
CREATE INDEX idx_sessions_deleted_at ON sessions(deleted_at);

CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_provider_id ON accounts(provider_id);
CREATE INDEX idx_accounts_account_id ON accounts(account_id);
CREATE INDEX idx_accounts_deleted_at ON accounts(deleted_at);

CREATE INDEX idx_verifications_identifier ON verifications(identifier);
CREATE INDEX idx_verifications_expires_at ON verifications(expires_at);
CREATE INDEX idx_verifications_deleted_at ON verifications(deleted_at);

-- organizations
CREATE INDEX idx_organizations_domain ON organizations(domain);
CREATE INDEX idx_organizations_status ON organizations(status);
CREATE INDEX idx_organizations_deleted_at ON organizations(deleted_at);

-- Professor packages
CREATE INDEX idx_professor_packages_is_active ON professor_packages(is_active);
CREATE INDEX idx_professor_packages_deleted_at ON professor_packages(deleted_at);

-- organization package purchases
CREATE INDEX idx_organization_package_purchases_organization_id ON organization_package_purchases(organization_id);
CREATE INDEX idx_organization_package_purchases_package_id ON organization_package_purchases(package_id);
CREATE INDEX idx_organization_package_purchases_payment_status ON organization_package_purchases(payment_status);
CREATE INDEX idx_organization_package_purchases_purchased_at ON organization_package_purchases(purchased_at);
CREATE INDEX idx_organization_package_purchases_expires_at ON organization_package_purchases(expires_at);
CREATE INDEX idx_organization_package_purchases_deleted_at ON organization_package_purchases(deleted_at);

-- Categories
CREATE INDEX idx_categories_organization_id ON categories(organization_id);
CREATE INDEX idx_categories_deleted_at ON categories(deleted_at);

-- Funds
CREATE INDEX idx_funds_code ON funds(code);
CREATE INDEX idx_funds_organization ON funds(organization);
CREATE INDEX idx_funds_deadline ON funds(deadline);
CREATE INDEX idx_funds_internal_deadline ON funds(internal_deadline);
CREATE INDEX idx_funds_category_id ON funds(category_id);
CREATE INDEX idx_funds_organization_id ON funds(organization_id);
CREATE INDEX idx_funds_created_by ON funds(created_by);
CREATE INDEX idx_funds_is_new ON funds(is_new);
CREATE INDEX idx_funds_deleted_at ON funds(deleted_at);

-- Fund tags
CREATE INDEX idx_fund_tags_name ON fund_tags(name);
CREATE INDEX idx_fund_tags_is_active ON fund_tags(is_active);
CREATE INDEX idx_fund_tags_deleted_at ON fund_tags(deleted_at);

-- Fund tag relationships
CREATE INDEX idx_fund_tag_relationships_fund_id ON fund_tag_relationships(fund_id);
CREATE INDEX idx_fund_tag_relationships_tag_id ON fund_tag_relationships(tag_id);
CREATE INDEX idx_fund_tag_relationships_deleted_at ON fund_tag_relationships(deleted_at);

-- Applications
CREATE INDEX idx_applications_fund_id ON applications(fund_id);
CREATE INDEX idx_applications_professor_id ON applications(professor_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_submitted_at ON applications(submitted_at);
CREATE INDEX idx_applications_deleted_at ON applications(deleted_at);

-- Application submissions
CREATE INDEX idx_application_submissions_application_id ON application_submissions(application_id);
CREATE INDEX idx_application_submissions_submission_number ON application_submissions(submission_number);
CREATE INDEX idx_application_submissions_submitted_at ON application_submissions(submitted_at);
CREATE INDEX idx_application_submissions_is_final ON application_submissions(is_final);
CREATE INDEX idx_application_submissions_deleted_at ON application_submissions(deleted_at);

-- Email notifications
CREATE INDEX idx_email_notifications_recipient_email ON email_notifications(recipient_email);
CREATE INDEX idx_email_notifications_notification_type ON email_notifications(notification_type);
CREATE INDEX idx_email_notifications_related_entity ON email_notifications(related_entity_type, related_entity_id);
CREATE INDEX idx_email_notifications_sent_at ON email_notifications(sent_at);
CREATE INDEX idx_email_notifications_delivery_status ON email_notifications(delivery_status);
CREATE INDEX idx_email_notifications_deleted_at ON email_notifications(deleted_at);

-- Submission notification recipients
CREATE INDEX idx_submission_notification_recipients_submission_id ON submission_notification_recipients(submission_id);
CREATE INDEX idx_submission_notification_recipients_recipient_type ON submission_notification_recipients(recipient_type);
CREATE INDEX idx_submission_notification_recipients_recipient_id ON submission_notification_recipients(recipient_id);
CREATE INDEX idx_submission_notification_recipients_recipient_email ON submission_notification_recipients(recipient_email);
CREATE INDEX idx_submission_notification_recipients_notification_sent ON submission_notification_recipients(notification_sent);
CREATE INDEX idx_submission_notification_recipients_deleted_at ON submission_notification_recipients(deleted_at);

-- Fund feedback
CREATE INDEX idx_fund_feedback_fund_id ON fund_feedback(fund_id);
CREATE INDEX idx_fund_feedback_professor_id ON fund_feedback(professor_id);
CREATE INDEX idx_fund_feedback_status ON fund_feedback(feedback_status);
CREATE INDEX idx_fund_feedback_deleted_at ON fund_feedback(deleted_at);

-- Application documents
CREATE INDEX idx_application_documents_application_id ON application_documents(application_id);
-- CREATE INDEX idx_application_documents_document_type ON application_documents(document_type);
CREATE INDEX idx_application_documents_deleted_at ON application_documents(deleted_at);

-- Reviewers
CREATE INDEX idx_reviewers_application_id ON reviewers(application_id);
CREATE INDEX idx_reviewers_reviewer_id ON reviewers(reviewer_id);
CREATE INDEX idx_reviewers_status ON reviewers(status);
CREATE INDEX idx_reviewers_deadline ON reviewers(deadline);
CREATE INDEX idx_reviewers_deleted_at ON reviewers(deleted_at);

-- Reviewer invitations
CREATE INDEX idx_reviewer_invitations_application_id ON reviewer_invitations(application_id);
CREATE INDEX idx_reviewer_invitations_reviewer_id ON reviewer_invitations(reviewer_id);
CREATE INDEX idx_reviewer_invitations_invited_by ON reviewer_invitations(invited_by);
CREATE INDEX idx_reviewer_invitations_status ON reviewer_invitations(invitation_status);
CREATE INDEX idx_reviewer_invitations_deadline ON reviewer_invitations(invitation_deadline);
CREATE INDEX idx_reviewer_invitations_review_deadline ON reviewer_invitations(review_deadline);
CREATE INDEX idx_reviewer_invitations_is_anonymous ON reviewer_invitations(is_anonymous);
CREATE INDEX idx_reviewer_invitations_deleted_at ON reviewer_invitations(deleted_at);

-- Reviewer documents
CREATE INDEX idx_reviewer_documents_reviewer_id ON reviewer_documents(reviewer_id);
-- CREATE INDEX idx_reviewer_documents_document_type ON reviewer_documents(document_type);
CREATE INDEX idx_reviewer_documents_deleted_at ON reviewer_documents(deleted_at);

-- Chat topics
CREATE INDEX idx_chat_topics_fund_id ON chat_topics(fund_id);
CREATE INDEX idx_chat_topics_topic_type ON chat_topics(topic_type);
CREATE INDEX idx_chat_topics_created_by ON chat_topics(created_by);
CREATE INDEX idx_chat_topics_is_active ON chat_topics(is_active);
CREATE INDEX idx_chat_topics_deleted_at ON chat_topics(deleted_at);

-- Chat topic participants
CREATE INDEX idx_chat_topic_participants_topic_id ON chat_topic_participants(topic_id);
CREATE INDEX idx_chat_topic_participants_user_id ON chat_topic_participants(user_id);
CREATE INDEX idx_chat_topic_participants_role ON chat_topic_participants(role);
CREATE INDEX idx_chat_topic_participants_can_send_message ON chat_topic_participants(can_send_message);
CREATE INDEX idx_chat_topic_participants_can_see_messages ON chat_topic_participants(can_see_messages);
CREATE INDEX idx_chat_topic_participants_joined_at ON chat_topic_participants(joined_at);
CREATE INDEX idx_chat_topic_participants_deleted_at ON chat_topic_participants(deleted_at);

-- Messages
CREATE INDEX idx_messages_topic_id ON messages(topic_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_sent_at ON messages(sent_at);
CREATE INDEX idx_messages_is_system_message ON messages(is_system_message);
CREATE INDEX idx_messages_deleted_at ON messages(deleted_at);

-- Message attachments
CREATE INDEX idx_message_attachments_message_id ON message_attachments(message_id);
CREATE INDEX idx_message_attachments_deleted_at ON message_attachments(deleted_at);

-- Message read status
CREATE INDEX idx_message_read_status_message_id ON message_read_status(message_id);
CREATE INDEX idx_message_read_status_user_id ON message_read_status(user_id);
CREATE INDEX idx_message_read_status_read_at ON message_read_status(read_at);
CREATE INDEX idx_message_read_status_deleted_at ON message_read_status(deleted_at);

-- Notifications
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_is_email_sent ON notifications(is_email_sent);
CREATE INDEX idx_notifications_sent_at ON notifications(sent_at);
CREATE INDEX idx_notifications_deleted_at ON notifications(deleted_at);

-- Notification templates
CREATE INDEX idx_notification_templates_type ON notification_templates(type);
CREATE INDEX idx_notification_templates_is_active ON notification_templates(is_active);
CREATE INDEX idx_notification_templates_deleted_at ON notification_templates(deleted_at);

-- User notification preferences
CREATE INDEX idx_user_notification_preferences_user_id ON user_notification_preferences(user_id);
CREATE INDEX idx_user_notification_preferences_type ON user_notification_preferences(notification_type);
CREATE INDEX idx_user_notification_preferences_in_app_enabled ON user_notification_preferences(in_app_enabled);
CREATE INDEX idx_user_notification_preferences_email_enabled ON user_notification_preferences(email_enabled);
CREATE INDEX idx_user_notification_preferences_deleted_at ON user_notification_preferences(deleted_at);

-- Fund favorites
CREATE INDEX idx_fund_favorites_user_id ON fund_favorites(user_id);
CREATE INDEX idx_fund_favorites_fund_id ON fund_favorites(fund_id);
CREATE INDEX idx_fund_favorites_deleted_at ON fund_favorites(deleted_at);

-- Permission requests
CREATE INDEX idx_permission_requests_fund_id ON permission_requests(fund_id);
CREATE INDEX idx_permission_requests_document_owner_email ON permission_requests(document_owner_email);
CREATE INDEX idx_permission_requests_status ON permission_requests(status);
CREATE INDEX idx_permission_requests_requested_by ON permission_requests(requested_by);
CREATE INDEX idx_permission_requests_deadline ON permission_requests(request_deadline);
CREATE INDEX idx_permission_requests_deleted_at ON permission_requests(deleted_at);

-- Audit logs
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_table_name ON audit_logs(table_name);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_audit_logs_deleted_at ON audit_logs(deleted_at);

-- Composite indexes for better performance
CREATE INDEX idx_applications_fund_professor ON applications(fund_id, professor_id);
CREATE INDEX idx_reviewers_application_reviewer ON reviewers(application_id, reviewer_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_fund_favorites_user_fund ON fund_favorites(user_id, fund_id);

-- Fulltext search indexes
CREATE INDEX idx_funds_search ON funds USING GIN(to_tsvector('english', title || ' ' || COALESCE(description, '') || ' ' || COALESCE(organization, '') || ' ' || COALESCE(keywords, '')));

-- Fulltext search for users
CREATE INDEX idx_users_search ON users USING GIN(to_tsvector('english', first_name || ' ' || COALESCE(last_name, '') || ' ' || COALESCE(email, '')));

-- =====================================================
-- VIEWS FOR SIMPLIFIED QUERIES
-- =====================================================

-- View for the list of funds with complete information
CREATE VIEW v_funds_complete AS
SELECT
    f.id, f.code, f.title, f.title_jp, f.description, f.organization, f.country,
    f.program_type, f.difficulty, f.application_start_date, f.deadline, f.internal_deadline,
    f.result_announcement, f.research_field, f.funding_period, f.funding_amount,
    f.funding_number, f.important_note, f.remark, f.graduated_student, f.relevancy,
    f.keywords, f.recruitment_requirement_url, f.homepage_url, f.format_file_url,
    f.example_file_url, f.is_new, f.created_at, f.updated_at,
    c.name as category_name, c.name_jp as category_name_jp,
    u.name as organization_name, u.name_jp as organization_name_jp,
    creator.first_name as created_by_name, creator.last_name as created_by_last_name
FROM funds f
LEFT JOIN categories c ON f.category_id = c.id
LEFT JOIN organizations u ON f.organization_id = u.id
LEFT JOIN users creator ON f.created_by = creator.id
WHERE f.deleted_at IS NULL;

-- View for the list of applications with complete information
CREATE VIEW v_applications_complete AS
SELECT
    a.id, a.submission_count, a.is_final, a.submitted_at,
    a.status, a.created_at, a.updated_at,
    f.title as fund_title, f.code as fund_code, f.organization as fund_organization,
    f.deadline as fund_deadline, f.internal_deadline as fund_internal_deadline,
    p.first_name as professor_first_name, p.last_name as professor_last_name,
    p.email as professor_email, p.username as professor_username,
    ff.feedback_status as professor_feedback,
    latest_submission.submission_number as latest_submission_number,
    latest_submission.submitted_at as latest_submission_date
FROM applications a
LEFT JOIN funds f ON a.fund_id = f.id
LEFT JOIN users p ON a.professor_id = p.id
LEFT JOIN fund_feedback ff ON a.fund_id = ff.fund_id AND a.professor_id = ff.professor_id
LEFT JOIN LATERAL (
    SELECT submission_number, submitted_at
    FROM application_submissions
    WHERE application_id = a.id AND deleted_at IS NULL
    ORDER BY submission_number DESC
    LIMIT 1
) latest_submission ON true
WHERE a.deleted_at IS NULL AND f.deleted_at IS NULL AND p.deleted_at IS NULL;

-- View for the history of submissions of an application
CREATE VIEW v_application_submissions_complete AS
SELECT
    s.id, s.submission_number, s.is_final, s.submitted_at,
    s.created_at, s.updated_at,
    a.id as application_id, a.status as application_status,
    f.title as fund_title, f.code as fund_code,
    p.first_name as professor_first_name, p.last_name as professor_last_name,
    p.email as professor_email,
    -- Count notification recipients
    COUNT(snr.id) as total_recipients,
    COUNT(CASE WHEN snr.notification_sent = true THEN 1 END) as notified_recipients,
    COUNT(CASE WHEN snr.notification_sent = false THEN 1 END) as pending_notifications
FROM application_submissions s
LEFT JOIN applications a ON s.application_id = a.id
LEFT JOIN funds f ON a.fund_id = f.id
LEFT JOIN users p ON a.professor_id = p.id
LEFT JOIN submission_notification_recipients snr ON s.id = snr.submission_id AND snr.deleted_at IS NULL
WHERE s.deleted_at IS NULL AND a.deleted_at IS NULL AND f.deleted_at IS NULL AND p.deleted_at IS NULL
GROUP BY s.id, s.submission_number, s.is_final, s.submitted_at, s.created_at, s.updated_at,
         a.id, a.status, f.title, f.code, p.first_name, p.last_name, p.email;

-- View for the list of reviewers with complete information
CREATE VIEW v_reviewers_complete AS
SELECT
    r.id, r.deadline, r.invited_at, r.agreed_at, r.declined_at, r.submitted_at,
    r.status, r.created_at, r.updated_at,
    a.id as application_id, f.title as fund_title, f.code as fund_code,
    p.first_name as professor_first_name, p.last_name as professor_last_name,
    reviewer.first_name as reviewer_first_name, reviewer.last_name as reviewer_last_name,
    reviewer.email as reviewer_email, reviewer.username as reviewer_username
FROM reviewers r
LEFT JOIN applications a ON r.application_id = a.id
LEFT JOIN funds f ON a.fund_id = f.id
LEFT JOIN users p ON a.professor_id = p.id
LEFT JOIN users reviewer ON r.reviewer_id = reviewer.id
WHERE r.deleted_at IS NULL AND a.deleted_at IS NULL AND f.deleted_at IS NULL
  AND p.deleted_at IS NULL AND reviewer.deleted_at IS NULL;

-- View for the list of reviewer invitations with complete information
CREATE VIEW v_reviewer_invitations_complete AS
SELECT
    ri.id, ri.invitation_status, ri.invitation_deadline, ri.review_deadline,
    ri.is_anonymous, ri.notes, ri.invited_at, ri.responded_at,
    ri.created_at, ri.updated_at,
    a.id as application_id, f.title as fund_title, f.code as fund_code,
    p.first_name as professor_first_name, p.last_name as professor_last_name,
    reviewer.first_name as reviewer_first_name, reviewer.last_name as reviewer_last_name,
    reviewer.email as reviewer_email, reviewer.username as reviewer_username,
    inviter.first_name as inviter_first_name, inviter.last_name as inviter_last_name,
    inviter.email as inviter_email
FROM reviewer_invitations ri
LEFT JOIN applications a ON ri.application_id = a.id
LEFT JOIN funds f ON a.fund_id = f.id
LEFT JOIN users p ON a.professor_id = p.id
LEFT JOIN users reviewer ON ri.reviewer_id = reviewer.id
LEFT JOIN users inviter ON ri.invited_by = inviter.id
WHERE ri.deleted_at IS NULL AND a.deleted_at IS NULL AND f.deleted_at IS NULL
  AND p.deleted_at IS NULL AND reviewer.deleted_at IS NULL AND inviter.deleted_at IS NULL;

-- View for the list of chat topics with complete information
CREATE VIEW v_chat_topics_complete AS
SELECT
    ct.id, ct.topic_type, ct.title, ct.description, ct.is_active,
    ct.created_at, ct.updated_at,
    f.id as fund_id, f.title as fund_title, f.code as fund_code,
    creator.first_name as created_by_first_name, creator.last_name as created_by_last_name,
    creator.email as created_by_email,
    -- Count participants
    COUNT(ctp.id) as participant_count,
    -- Count unread messages for each participant
    COUNT(DISTINCT ctp.user_id) as active_participants
FROM chat_topics ct
LEFT JOIN funds f ON ct.fund_id = f.id
LEFT JOIN users creator ON ct.created_by = creator.id
LEFT JOIN chat_topic_participants ctp ON ct.id = ctp.topic_id AND ctp.deleted_at IS NULL
WHERE ct.deleted_at IS NULL AND f.deleted_at IS NULL AND creator.deleted_at IS NULL
GROUP BY ct.id, ct.topic_type, ct.title, ct.description, ct.is_active, ct.created_at, ct.updated_at,
         f.id, f.title, f.code, creator.first_name, creator.last_name, creator.email;

-- View for the list of messages with complete information
CREATE VIEW v_messages_complete AS
SELECT
    m.id, m.content, m.message_type, m.is_system_message, m.sent_at,
    m.created_at, m.updated_at,
    ct.id as topic_id, ct.topic_type, ct.title as topic_title,
    f.id as fund_id, f.title as fund_title,
    sender.first_name as sender_first_name, sender.last_name as sender_last_name,
    sender.email as sender_email, sender.username as sender_username,
    sender.role as sender_role,
    -- Check if current user has read this message
    CASE WHEN mrs.read_at IS NOT NULL THEN true ELSE false END as is_read_by_current_user,
    mrs.read_at as read_at
FROM messages m
LEFT JOIN chat_topics ct ON m.topic_id = ct.id
LEFT JOIN funds f ON ct.fund_id = f.id
LEFT JOIN users sender ON m.sender_id = sender.id
LEFT JOIN message_read_status mrs ON m.id = mrs.message_id
WHERE m.deleted_at IS NULL AND ct.deleted_at IS NULL AND f.deleted_at IS NULL AND sender.deleted_at IS NULL;

-- View for the list of chat topic participants with complete information
CREATE VIEW v_chat_topic_participants_complete AS
SELECT
    ctp.id, ctp.role, ctp.can_send_message, ctp.can_see_messages,
    ctp.joined_at, ctp.left_at, ctp.created_at, ctp.updated_at,
    ct.id as topic_id, ct.topic_type, ct.title as topic_title,
    f.id as fund_id, f.title as fund_title,
    u.id as user_id, u.first_name, u.last_name, u.email, u.username,
    u.role as user_role, u.organization_id,
    un.name as organization_name
FROM chat_topic_participants ctp
LEFT JOIN chat_topics ct ON ctp.topic_id = ct.id
LEFT JOIN funds f ON ct.fund_id = f.id
LEFT JOIN users u ON ctp.user_id = u.id
LEFT JOIN organizations un ON u.organization_id = un.id
WHERE ctp.deleted_at IS NULL AND ct.deleted_at IS NULL AND f.deleted_at IS NULL
  AND u.deleted_at IS NULL AND un.deleted_at IS NULL;

-- View for the information of organizations with professor limits
CREATE VIEW v_organizations_with_professor_limits AS
SELECT
    u.id, u.name, u.name_jp, u.domain, u.status,
    u.default_professor_limit, u.current_professor_count,
    (u.default_professor_limit + COALESCE(SUM(upp.quantity * pp.professor_count), 0)) as total_professor_limit,
    (u.default_professor_limit + COALESCE(SUM(upp.quantity * pp.professor_count), 0) - u.current_professor_count) as available_professor_slots,
    u.created_at, u.updated_at
FROM organizations u
LEFT JOIN organization_package_purchases upp ON u.id = upp.organization_id
    AND upp.payment_status = 'completed'
    AND (upp.expires_at IS NULL OR upp.expires_at > CURRENT_TIMESTAMP)
    AND upp.deleted_at IS NULL
LEFT JOIN professor_packages pp ON upp.package_id = pp.id AND pp.deleted_at IS NULL
WHERE u.deleted_at IS NULL
GROUP BY u.id, u.name, u.name_jp, u.domain, u.status, u.default_professor_limit, u.current_professor_count, u.created_at, u.updated_at;

-- View for the list of notifications with complete information
CREATE VIEW v_notifications_complete AS
SELECT
    n.id, n.type, n.title, n.message, n.related_id, n.related_type,
    n.is_read, n.is_email_sent, n.email_sent_at, n.sent_at,
    n.created_at, n.updated_at,
    u.id as user_id, u.first_name, u.last_name, u.email, u.username,
    u.role, u.organization_id,
    un.name as organization_name,
    -- Count unread notifications for this user
    (SELECT COUNT(*) FROM notifications n2
     WHERE n2.user_id = n.user_id AND n2.is_read = false AND n2.deleted_at IS NULL) as total_unread_count
FROM notifications n
LEFT JOIN users u ON n.user_id = u.id
LEFT JOIN organizations un ON u.organization_id = un.id
WHERE n.deleted_at IS NULL AND u.deleted_at IS NULL;

-- View for the list of user notification preferences with complete information
CREATE VIEW v_user_notification_preferences_complete AS
SELECT
    unp.id, unp.notification_type, unp.in_app_enabled, unp.email_enabled,
    unp.created_at, unp.updated_at,
    u.id as user_id, u.first_name, u.last_name, u.email, u.username,
    u.role, u.organization_id,
    un.name as organization_name,
    nt.title_template, nt.message_template
FROM user_notification_preferences unp
LEFT JOIN users u ON unp.user_id = u.id
LEFT JOIN organizations un ON u.organization_id = un.id
LEFT JOIN notification_templates nt ON unp.notification_type = nt.type AND nt.deleted_at IS NULL
WHERE unp.deleted_at IS NULL AND u.deleted_at IS NULL;

-- =====================================================
-- FUNCTIONS AND TRIGGERS
-- =====================================================

-- Function to automatically update is_new for funds after 7 days
CREATE OR REPLACE FUNCTION update_fund_is_new()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.created_at < CURRENT_TIMESTAMP - INTERVAL '7 days' THEN
        NEW.is_new = FALSE;
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Function to automatically update current_professor_count when user is created/deleted
CREATE OR REPLACE FUNCTION update_organization_professor_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.role = 'professor' AND NEW.organization_id IS NOT NULL THEN
        UPDATE organizations
        SET current_professor_count = current_professor_count + 1
        WHERE id = NEW.organization_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' AND OLD.role = 'professor' AND OLD.organization_id IS NOT NULL THEN
        UPDATE organizations
        SET current_professor_count = current_professor_count - 1
        WHERE id = OLD.organization_id;
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' AND NEW.role = 'professor' THEN
        -- If organization_id changed
        IF OLD.organization_id IS DISTINCT FROM NEW.organization_id THEN
            -- Decrease count from old organization
            IF OLD.organization_id IS NOT NULL THEN
                UPDATE organizations
                SET current_professor_count = current_professor_count - 1
                WHERE id = OLD.organization_id;
            END IF;
            -- Increase count for new organization
            IF NEW.organization_id IS NOT NULL THEN
                UPDATE organizations
                SET current_professor_count = current_professor_count + 1
                WHERE id = NEW.organization_id;
            END IF;
        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- Function to create audit log
CREATE OR REPLACE FUNCTION create_audit_log()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
        VALUES (
            current_setting('app.current_user_id', true),
            'UPDATE',
            TG_TABLE_NAME,
            NEW.id,
            to_jsonb(OLD),
            to_jsonb(NEW)
        );
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, new_values)
        VALUES (
            current_setting('app.current_user_id', true),
            'INSERT',
            TG_TABLE_NAME,
            NEW.id,
            to_jsonb(NEW)
        );
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values)
        VALUES (
            current_setting('app.current_user_id', true),
            'DELETE',
            TG_TABLE_NAME,
            OLD.id,
            to_jsonb(OLD)
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- Trigger for is_new
CREATE TRIGGER update_fund_is_new_trigger BEFORE INSERT OR UPDATE ON funds FOR EACH ROW EXECUTE FUNCTION update_fund_is_new();

-- Trigger for professor count
CREATE TRIGGER update_organization_professor_count_trigger
    AFTER INSERT OR UPDATE OR DELETE ON users
    FOR EACH ROW EXECUTE FUNCTION update_organization_professor_count();

-- Audit triggers (commented out for now - uncomment if needed)
-- CREATE TRIGGER audit_organizations AFTER INSERT OR UPDATE OR DELETE ON organizations FOR EACH ROW EXECUTE FUNCTION create_audit_log();
-- CREATE TRIGGER audit_categories AFTER INSERT OR UPDATE OR DELETE ON categories FOR EACH ROW EXECUTE FUNCTION create_audit_log();
-- CREATE TRIGGER audit_users AFTER INSERT OR UPDATE OR DELETE ON users FOR EACH ROW EXECUTE FUNCTION create_audit_log();
-- CREATE TRIGGER audit_funds AFTER INSERT OR UPDATE OR DELETE ON funds FOR EACH ROW EXECUTE FUNCTION create_audit_log();
-- CREATE TRIGGER audit_applications AFTER INSERT OR UPDATE OR DELETE ON applications FOR EACH ROW EXECUTE FUNCTION create_audit_log();
-- CREATE TRIGGER audit_reviewers AFTER INSERT OR UPDATE OR DELETE ON reviewers FOR EACH ROW EXECUTE FUNCTION create_audit_log();

-- =====================================================
-- COMMENTS
-- =====================================================

-- Better Auth tables
COMMENT ON TABLE users IS 'Better Auth: Table to store user information';
COMMENT ON TABLE sessions IS 'Better Auth: Table to store session information';
COMMENT ON TABLE accounts IS 'Better Auth: Table to store OAuth accounts and credentials';
COMMENT ON TABLE verifications IS 'Better Auth: Table to store email verification codes and reset password codes';

-- Fund management tables
COMMENT ON TABLE organizations IS 'Table to store information of organizations';
COMMENT ON TABLE professor_packages IS 'Table to store information of professor packages';
COMMENT ON TABLE organization_package_purchases IS 'Table to store information of organization package purchases';
COMMENT ON TABLE categories IS 'Table to store information of categories';
COMMENT ON TABLE funds IS 'Table to store information of funds';
COMMENT ON TABLE fund_tags IS 'Table to store information of fund tags';
COMMENT ON TABLE fund_tag_relationships IS 'Table to store information of fund tag relationships';
COMMENT ON TABLE applications IS 'Table to store information of applications';
COMMENT ON TABLE application_submissions IS 'Table to store information of application submissions';
COMMENT ON TABLE email_notifications IS 'Table to store information of email notifications';
COMMENT ON TABLE submission_notification_recipients IS 'Table to store information of submission notification recipients';
COMMENT ON TABLE fund_feedback IS 'Table to store information of fund feedback';
COMMENT ON TABLE application_documents IS 'Table to store information of application documents';
COMMENT ON TABLE reviewers IS 'Table to store information of reviewers';
COMMENT ON TABLE reviewer_invitations IS 'Table to store information of reviewer invitations';
COMMENT ON TABLE reviewer_documents IS 'Table to store information of reviewer documents';
COMMENT ON TABLE permission_requests IS 'Table to store information of permission requests';
COMMENT ON TABLE chat_topics IS 'Table to store information of chat topics';
COMMENT ON TABLE chat_topic_participants IS 'Table to store information of chat topic participants';
COMMENT ON TABLE messages IS 'Table to store information of messages';
COMMENT ON TABLE message_attachments IS 'Table to store information of message attachments';
COMMENT ON TABLE message_read_status IS 'Table to store information of message read status';
COMMENT ON TABLE notifications IS 'Table to store information of notifications';
COMMENT ON TABLE notification_templates IS 'Table to store information of notification templates';
COMMENT ON TABLE user_notification_preferences IS 'Table to store information of user notification preferences';
COMMENT ON TABLE fund_favorites IS 'Table to store information of fund favorites';
COMMENT ON TABLE audit_logs IS 'Table to store information of audit logs';
COMMENT ON TABLE passkeys IS 'Table to store information of passkeys';
COMMENT ON TABLE two_factors IS 'Table to store information of two factors';

-- =====================================================
-- SAMPLE DATA (OPTIONAL)
-- =====================================================

-- Insert sample organizations
INSERT INTO organizations (name, name_jp, domain, status) VALUES
('Tokyo organization', '東京大学', 'u-tokyo.ac.jp', 'active'),
('Kyoto organization', '京都大学', 'kyoto-u.ac.jp', 'active'),
('Osaka organization', '大阪大学', 'osaka-u.ac.jp', 'active');

-- Insert sample professor packages
INSERT INTO professor_packages (name, name_jp, description, professor_count, price, duration_months) VALUES
('Basic Package', 'ベーシックパッケージ', '10 additional professors for 1 year', 10, 50000.00, 12),
('Standard Package', 'スタンダードパッケージ', '25 additional professors for 1 year', 25, 100000.00, 12),
('Premium Package', 'プレミアムパッケージ', '50 additional professors for 1 year', 50, 180000.00, 12),
('Enterprise Package', 'エンタープライズパッケージ', '100 additional professors for 1 year', 100, 300000.00, 12);

-- Insert sample categories
INSERT INTO categories (name, name_jp, organization_id) VALUES
('Internal Funds', '内部資金', 1),
('Government Funds', '政府資金', 1),
('Private Organization Funds', '民間組織資金', 1);

-- Insert sample users (Better Auth compatible)
INSERT INTO users (id, first_name, last_name, email, username, role, organization_id, status, is_email_verified) VALUES
('user-1', 'Admin', 'User', 'admin@u-tokyo.ac.jp', 'admin', 'admin', 1, 'active', true),
('user-2', 'Staff', 'User', 'staff@u-tokyo.ac.jp', 'staff', 'staff', 1, 'active', true),
('user-3', 'Professor', 'User', 'professor@u-tokyo.ac.jp', 'professor', 'professor', 1, 'active', true);

-- Insert sample fund tags
INSERT INTO fund_tags (name, name_jp, description, color) VALUES
('AI/ML', 'AI/ML', 'Artificial Intelligence and Machine Learning', '#ff6b6b'),
('Biotechnology', 'バイオテクノロジー', 'Biotechnology and Life Sciences', '#4ecdc4'),
('Engineering', '工学', 'Engineering and Technology', '#45b7d1'),
('Medicine', '医学', 'Medical and Health Sciences', '#96ceb4'),
('Chemistry', '化学', 'Chemistry and Materials Science', '#feca57'),
('Physics', '物理学', 'Physics and Astronomy', '#ff9ff3');

-- Insert sample funds
INSERT INTO funds (code, title, organization, deadline, internal_deadline, created_by, category_id, organization_id) VALUES
('FUND-001', 'Research Grant 2024', 'JSPS', '2024-12-31', '2024-11-30', 'user-2', 1, 1),
('FUND-002', 'Innovation Award', 'MEXT', '2024-10-31', '2024-09-30', 'user-2', 2, 1);

-- Insert sample fund tag relationships
INSERT INTO fund_tag_relationships (fund_id, tag_id) VALUES
(1, 1), -- FUND-001 -> AI/ML
(1, 3), -- FUND-001 -> Engineering
(2, 2), -- FUND-002 -> Biotechnology
(2, 4); -- FUND-002 -> Medicine

-- Insert sample fund feedback
INSERT INTO fund_feedback (fund_id, professor_id, feedback_status, notes) VALUES
(1, 'user-3', 'will_apply', 'Very interested in this research area'),
(2, 'user-3', 'considering', 'Need to review requirements more carefully');

-- Insert sample email notifications
INSERT INTO email_notifications (recipient_email, recipient_name, subject, content, notification_type, related_entity_type, related_entity_id) VALUES
('reviewer1@example.com', 'Reviewer One', 'New Application Submission', 'A new application has been submitted...', 'application_submitted', 'application', 1),
('staff@u-tokyo.ac.jp', 'Staff User', 'Application Updated', 'An application has been updated...', 'application_updated', 'application', 1);

-- Insert sample notification templates
INSERT INTO notification_templates (type, title_template, message_template, email_subject_template, email_body_template) VALUES
('user_registration', 'Welcome {user_name} to the system', 'Your account has been created successfully. Please verify your email to activate your account.', 'Welcome to Fund Management System', 'Hello {user_name},<br><br>Your account has been created successfully...'),
('fund_created', 'New fund: {fund_title}', 'Fund {fund_title} has been created by {created_by}. Please check and approve.', 'New fund: {fund_title}', 'Fund {fund_title} has been created...'),
('application_submitted', 'New application: {fund_title}', 'Professor {professor_name} has submitted an application for fund {fund_title}.', 'New application: {fund_title}', 'Professor {professor_name} has submitted an application...'),
('reviewer_invited', 'Reviewer invited: {fund_title}', 'You have been invited to review the application for fund {fund_title}. Deadline: {deadline}', 'Reviewer invited: {fund_title}', 'You have been invited to review...'),
('review_submitted', 'Review submitted: {fund_title}', 'Reviewer {reviewer_name} has submitted the evaluation for application {fund_title}.', 'Review submitted: {fund_title}', 'Reviewer {reviewer_name} has submitted...'),
('application_status_changed', 'Application status changed: {fund_title}', 'Application {fund_title} has been changed from {old_status} to {new_status}.', 'Application status changed', 'Application {fund_title} has been changed...'),
('deadline_reminder', 'Deadline reminder: {fund_title}', 'Fund {fund_title} will expire on {deadline}. Please complete the application.', 'Deadline reminder: {fund_title}', 'Fund {fund_title} will expire...'),
('system_alert', 'System alert: {title}', '{message}', 'System alert: {title}', '{message}');

-- Insert sample user notification preferences
INSERT INTO user_notification_preferences (user_id, notification_type, in_app_enabled, email_enabled) VALUES
('user-1', 'user_registration', true, true),
('user-1', 'fund_created', true, true),
('user-1', 'application_submitted', true, false),
('user-1', 'reviewer_invited', true, true),
('user-1', 'review_submitted', true, true),
('user-1', 'application_status_changed', true, true),
('user-1', 'deadline_reminder', true, true),
('user-1', 'system_alert', true, true),
('user-2', 'user_registration', true, true),
('user-2', 'fund_created', true, true),
('user-2', 'application_submitted', true, true),
('user-2', 'reviewer_invited', false, false),
('user-2', 'review_submitted', true, true),
('user-2', 'application_status_changed', true, true),
('user-2', 'deadline_reminder', true, true),
('user-2', 'system_alert', true, true),
('user-3', 'user_registration', true, true),
('user-3', 'fund_created', true, false),
('user-3', 'application_submitted', true, true),
('user-3', 'reviewer_invited', true, true),
('user-3', 'review_submitted', true, true),
('user-3', 'application_status_changed', true, true),
('user-3', 'deadline_reminder', true, true),
('user-3', 'system_alert', true, false);

-- Insert sample notifications
INSERT INTO notifications (user_id, type, title, message, related_id, related_type, is_read, is_email_sent) VALUES
('user-2', 'application_submitted', 'New application: Research Grant 2024', 'Professor Professor User has submitted an application for fund Research Grant 2024.', 1, 'application', false, true),
('user-3', 'reviewer_invited', 'Reviewer invited: Research Grant 2024', 'You have been invited to review the application for fund Research Grant 2024. Deadline: 2024-02-15', 1, 'application', false, false),
('user-1', 'fund_created', 'New fund: Innovation Award', 'Fund Innovation Award has been created by Staff User. Please check and approve.', 2, 'fund', true, true);

-- Insert sample chat topics
INSERT INTO chat_topics (fund_id, topic_type, title, description, created_by) VALUES
(1, 'fund_general', 'Research Grant 2024 - General Discussion', 'General chat for fund Research Grant 2024', 'user-2'),
(1, 'professor_staff', 'Research Grant 2024 - Professor-Staff Chat', 'Private chat between professor and staff', 'user-2'),
(1, 'professor_reviewer', 'Research Grant 2024 - Professor-Reviewer Chat', 'Private chat between professor and reviewer', 'user-3'),
(2, 'fund_general', 'Innovation Award - General Discussion', 'General chat for fund Innovation Award', 'user-2');

-- Insert sample chat topic participants
INSERT INTO chat_topic_participants (topic_id, user_id, role) VALUES
-- Fund general chat (all can join)
(1, 'user-1', 'admin'),
(1, 'user-2', 'staff'),
(1, 'user-3', 'professor'),
-- Professor-Staff chat (only professor and staff can join)
(2, 'user-2', 'staff'),
(2, 'user-3', 'professor'),
-- Professor-Reviewer chat (only professor and reviewer invited by professor can join)
(3, 'user-3', 'professor'),
-- Innovation Award general chat
(4, 'user-1', 'admin'),
(4, 'user-2', 'staff');

-- Insert sample messages
INSERT INTO messages (topic_id, sender_id, content, message_type) VALUES
(1, 'user-2', 'Welcome to the general chat of the Research Grant 2024!', 'system'),
(1, 'user-3', 'Thank you! I have some questions about the requirements of this fund.', 'text'),
(1, 'user-2', 'Please ask, I will answer right away.', 'text'),
(2, 'user-3', 'Hello, I want to discuss my application.', 'text'),
(2, 'user-2', 'Hello! I have received your application and am reviewing it.', 'text'),
(3, 'user-3', 'Thank you for accepting my review. I look forward to your feedback.', 'text');

-- Insert sample message read status
INSERT INTO message_read_status (message_id, user_id) VALUES
(1, 'user-1'), (1, 'user-2'), (1, 'user-3'),
(2, 'user-2'), (2, 'user-3'),
(3, 'user-2'), (3, 'user-3'),
(4, 'user-2'), (4, 'user-3'),
(5, 'user-2'), (5, 'user-3'),
(6, 'user-3');
