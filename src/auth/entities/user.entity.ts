import { Role } from '@/api/user/user.enum';
import { BaseModel } from '@/database/models/base.model';
import { Column, Entity, Index } from 'typeorm';

// https://www.better-auth.com/docs/concepts/database#core-schema
@Entity('users')
export class UserEntity extends BaseModel {
  @Index({ unique: true, where: '"deleted_at" IS NULL' })
  @Column()
  username: string;

  @Index({ unique: true, where: '"deleted_at" IS NULL' })
  @Column()
  email: string;

  @Column({ type: 'boolean', default: false, name: 'is_email_verified' })
  isEmailVerified: boolean;

  @Column({
    type: 'enum',
    enum: Role,
    default: Role.Professor,
  })
  role: Role;

  @Column({ nullable: true, name: 'first_name' })
  firstName?: string;

  @Column({ nullable: true, name: 'last_name' })
  lastName?: string;

  @Column({ nullable: true })
  image?: string;

  @Column({ nullable: true })
  bio?: string;

  @Column({ nullable: true, name: 'university_id' })
  universityId?: string;

  @Column({ nullable: true, default: 'pending' })
  status?: string;

  @Column({ nullable: true, name: 'last_login_at' })
  lastLoginAt?: Date;

  @Column({ nullable: true })
  phone?: string;

  @Column({ nullable: true })
  address?: string;

  @Column({ nullable: true })
  department?: string;

  @Column({ nullable: true })
  position?: string;

  @Column({ nullable: true, name: 'research_field' })
  researchField?: string;

  @Column({ type: 'boolean', default: false, name: 'two_factor_enabled' })
  twoFactorEnabled: boolean;
}
