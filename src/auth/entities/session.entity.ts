import { BaseModel } from '@/database/models/base.model';
import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { UserEntity } from './user.entity';

// Although, we'll use Redis for storing sessions, we can fallback to this if you want to store sessions in database
// https://www.better-auth.com/docs/concepts/database#core-schema
@Entity('sessions')
export class SessionEntity extends BaseModel {
  @Column({ name: 'user_id' })
  userId: string;

  @ManyToOne(() => UserEntity, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;

  @Column()
  token: string;

  @Column({ type: 'timestamp', name: 'expires_at' })
  expiresAt: Date;

  @Column({ nullable: true, name: 'ip_address' })
  ipAddress: string;

  @Column({ nullable: true, name: 'user_agent' })
  userAgent: string;
}
